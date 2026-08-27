import 'dart:convert';
import 'dart:io';
import 'package:deero_advert_app/core/constant.dart';
import 'package:deero_advert_app/features/auth/models/user_model.dart';
import 'package:deero_advert_app/main.dart';
import 'package:flutter/material.dart';
import 'package:deero_advert_app/main.dart'; // Add this for navigatorKey
import 'package:provider/provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/notification_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart' as gsi;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;
  bool isLoading = false;

  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final gsi.GoogleSignIn _googleSignIn = gsi.GoogleSignIn(scopes: ['email']);

  Future<bool> signInWithGoogle(BuildContext context) async {
    try {
      isLoading = true;
      loginError = null;
      notifyListeners();

      final gsi.GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading = false;
        notifyListeners();
        return false;
      }

      final auth = await googleUser.authentication;
      final firebase_auth.AuthCredential credential =
          firebase_auth.GoogleAuthProvider.credential(
            accessToken: auth.accessToken,
            idToken: auth.idToken,
          );

      final firebase_auth.UserCredential userCredential = await _auth
          .signInWithCredential(credential);
      final firebase_auth.User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Prepare data for backend sync
        var data = {
          "email": firebaseUser.email,
          "name": firebaseUser.displayName,
          "image": firebaseUser.photoURL,
          "googleId": firebaseUser.uid,
          "isGoogleLogin": true,
          "phone": firebaseUser.phoneNumber,
        };

        print("Backend Sync Data: $data");

        var response = await http.post(
          Uri.parse(
            "${EndPoint}users/google-login",
          ), // Endpoint for Google sync
          body: jsonEncode(data),
          headers: {"Content-Type": "application/json"},
        );

        print("Backend Response Status: ${response.statusCode}");
        print("Backend Response Body: ${response.body}");

        if (response.statusCode == 200) {
          var datadecoded = jsonDecode(response.body);
          userModel = UserModel.fromJson(datadecoded);
          final model = userModel;
          if (model != null) {
            saveUser(model);
          }
          print("Google Sign-In Sync Successful!");
          isLoading = false;
          notifyListeners();
          return true;
        } else {
          print("Backend Sync Failed with status: ${response.statusCode}");
          loginError = "Failed to sync with server.";
          isLoading = false;
          notifyListeners();
          return false;
        }
      }
      return false;
    } catch (e) {
      print("CRITICAL ERROR during Google Sign-In: $e");
      loginError = "Google login failed: $e";
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  String? _email;
  String? _password;

  UserProvider() {
    getUser();
  }

  final box = GetStorage();

  String? get email => _email;
  String? get password => _password;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  String? loginError;

  Future<bool> login(BuildContext context) async {
    try {
      isLoading = true;
      loginError = null;
      notifyListeners();
      var data = {"email": email, "password": password};

      var response = await http.post(
        Uri.parse(EndPoint + "users/login"),
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        var datadecoded = jsonDecode(response.body);
        userModel = UserModel.fromJson(datadecoded);
        final model = userModel;
        if (model != null) {
          saveUser(model);
        }
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        loginError = "Invalid email or password";
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      loginError = "Connection error. Please try again.";
      isLoading = false;
      notifyListeners();
      print(e);
      return false;
    }
  }

  void saveUser(UserModel user) {
    this.userModel = user;
    box.write("userInfo", user.toJson());
    box.write(isLogged, true);
    
    // Also save device token with the new userId
    try {
      final context = navigatorKey.currentContext;
      if (context != null) {
        Provider.of<NotificationProvider>(context, listen: false).saveToken();
      }
    } catch (e) {
      print("Error calling saveToken from saveUser: $e");
    }
    
    notifyListeners();
  }

  void getUser() {
    var hasdata = box.hasData("userInfo");

    if (hasdata == true) {
      var data = box.read("userInfo");
      userModel = UserModel.fromJson(data);
      notifyListeners();
    }
    print("hasdata" + hasdata.toString());
  }

  List<BonusHistory> bonusHistory = [];
  bool isHistoryLoading = false;

  int minBonusForDiscount = 100; // 100 points to unlock discount
  int discountPercentage = 50; // 50% discount (hardcoded default)

  /// "All Users" discounts — visible without login
  List<Discount> globalDiscounts = [];

  Future<void> fetchGlobalDiscounts() async {
    try {
      final response = await http.get(
        Uri.parse("${EndPoint}discounts/public"),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['discounts'];
        if (list is List) {
          globalDiscounts =
              list.map((e) => Discount.fromJson(e)).toList();
          notifyListeners();
        }
      }
    } catch (e) {
      print("Failed to fetch global discounts: $e");
    }
  }

  /// Global + (if logged in) user-specific discounts
  List<Discount> get allApplicableDiscounts {
    final map = <String, Discount>{};
    for (final d in globalDiscounts) {
      final key = d.id?.toString() ??
          "${d.targetType}-${d.targetId}-${d.discountValue}";
      map[key] = d;
    }
    for (final d in userModel?.user?.discounts ?? <Discount>[]) {
      final key = d.id?.toString() ??
          "${d.targetType}-${d.targetId}-${d.discountValue}";
      map[key] = d;
    }
    return map.values.toList();
  }

  Future<void> getBonusHistoryLocal() async {
    final userId = userModel?.user?.id;
    if (userId == null) return;
    try {
      isHistoryLoading = true;
      notifyListeners();

      var response = await http.get(
        Uri.parse("${EndPoint}users/$userId/bonus-history"),
        headers: {
          "Content-Type": "application/json",
          if (userModel?.token != null)
            "Authorization": "Bearer ${userModel!.token}",
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          var historyList = data['history'] as List?;
          if (historyList != null) {
            bonusHistory = historyList
                .map((e) => BonusHistory.fromJson(e))
                .toList();
          }
        }
      }
    } catch (e) {
      print("Error fetching bonus history: $e");
    } finally {
      isHistoryLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUser() async {
    final currentModel = userModel;
    final userId = currentModel?.user?.id;
    if (userId == null) {
      print("Cannot refresh user: userId is null");
      return;
    }

    try {
      // 2 second delay to ensure backend has finished processing the transaction
      await Future.delayed(const Duration(seconds: 2));

      print("Refreshing user data for ID: $userId");
      final token = currentModel?.token;

      var response = await http.get(
        Uri.parse("${EndPoint}users/$userId"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      print("Refresh Response Status: ${response.statusCode}");
      print("Refresh Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // The backend might return { "user": { ... } } or just { ... }
        // Based on the log, it's returning the user object directly at the root
        final dynamic userJson = data['user'] ?? data;

        if (userJson != null && userModel != null) {
          final newUser = User.fromJson(userJson);

          final oldBonus = userModel?.user?.bonus;
          final newBonus = newUser.bonus ?? 0;

          // Create a new instance to ensure Provider detects the change
          final updatedModel = UserModel(
            message: userModel?.message,
            token: userModel?.token,
            user: newUser,
          );

          saveUser(updatedModel);
          print("User data refreshed. Bonus: $oldBonus -> $newBonus");

          // Notify if bonus increased (Accumulated)
          if (newBonus > (oldBonus ?? 0)) {
            final earned = newBonus - (oldBonus ?? 0);
            NotificationService.show(
              "💰 Bonus Accumulated!",
              "Congratulations! You've earned $earned points. Total balance: $newBonus points.",
              saveLocal: true,
            );
          }

          // Check for bonus notification (Discount reminder) using dynamic threshold
          if (newBonus >= minBonusForDiscount) {
            checkBonusNotification(newBonus);
          }

          // Also refresh bonus history
          await getBonusHistoryLocal();
        } else {
          print("Refresh failed: User data not found in response");
        }
      } else {
        print("Refresh failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error refreshing user: $e");
    }
  }

  void checkBonusNotification(int bonus) {
    if (bonus >= minBonusForDiscount) {
      final box = GetStorage();
      final lastNotifiedBonus = box.read('last_notified_bonus_peak') ?? 0;

      // Only notify if they haven't been notified for this specific milestone
      if (lastNotifiedBonus < minBonusForDiscount) {
        NotificationService.show(
          "🎁 $discountPercentage% DISCOUNT READY!",
          "You have reached $bonus points! You can now get $discountPercentage% OFF on any Service, Domain, or Hosting. Don't miss out!",
          saveLocal: true,
        );
        box.write('last_notified_bonus_peak', minBonusForDiscount);
      }
    } else if (bonus < minBonusForDiscount) {
      // Reset if they use the bonus
      box.write('last_notified_bonus_peak', 0);
    }
  }

  void logout() {
    box.remove("userInfo");
    box.remove(isLogged);
    notifyListeners();
  }

  /// Matches discounts for [targetType] against [targetId] and optional
  /// [alsoMatchIds] (e.g. service id + package ids).
  /// Includes global ("All Users") discounts even when guest / not logged in.
  Discount? getBestDiscount(
    String targetType,
    String targetId, {
    List<String>? alsoMatchIds,
  }) {
    final source = allApplicableDiscounts;
    if (source.isEmpty) return null;

    final ids = <String>{
      targetId.toString(),
      ...?alsoMatchIds?.map((id) => id.toString()),
    }.where((id) => id.isNotEmpty && id != "null").toSet();

    final applicable = source.where((d) {
      if (!d.isCurrentlyActive) return false;

      final type = (d.targetType ?? "").toLowerCase();
      final targetMatch =
          type == targetType.toLowerCase() || type == "all";

      final discountTargetId = d.targetId?.toString();
      final idMatch = discountTargetId == null ||
          discountTargetId.isEmpty ||
          discountTargetId == "all" ||
          ids.contains(discountTargetId);

      return targetMatch && idMatch;
    }).toList();

    if (applicable.isEmpty) return null;

    applicable.sort(
      (a, b) => (b.discountValue ?? 0).compareTo(a.discountValue ?? 0),
    );

    return applicable[0];
  }

  /// Best badge text for a service (checks service id + all package ids).
  String? getServiceDiscountBadge(
    String? serviceId, {
    List<String>? packageIds,
  }) {
    final best = getBestDiscount(
      "service",
      serviceId ?? "all",
      alsoMatchIds: packageIds,
    );
    if (best != null) return best.badgeLabel;

    // Bonus discount only for logged-in users who unlocked it
    if (userModel?.user?.bonusStatus == "BonusAvailable") {
      return "$discountPercentage% OFF";
    }
    return null;
  }

  Future<bool> updateProfile({
    required String fullname,
    required String email,
    required String phone,
    File? imageFile,
  }) async {
    final userId = userModel?.user?.id;
    if (userId == null) return false;

    try {
      isLoading = true;
      notifyListeners();

      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse("${EndPoint}users/$userId"),
      );

      request.headers.addAll({
        if (userModel?.token != null)
          "Authorization": "Bearer ${userModel!.token}",
      });

      request.fields['fullname'] = fullname;
      request.fields['email'] = email;
      request.fields['phone'] = phone;

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("Update Profile Status: ${response.statusCode}");
      print("Update Profile Body: ${response.body}");

      if (response.statusCode == 200) {
        // Refresh local data
        await refreshUser();
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("Error updating profile: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
