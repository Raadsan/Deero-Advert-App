import 'dart:convert';

import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/auth/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/notification_provider.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;
  bool isLoading = false;

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

  Future<void> getBonusHistoryLocal() async {
    final userId = userModel?.user?.id;
    if (userId == null) return;
    try {
      isHistoryLoading = true;
      notifyListeners();

      var response = await http.get(
        Uri.parse("${EndPoint}users/bonus-history/$userId"),
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
}
