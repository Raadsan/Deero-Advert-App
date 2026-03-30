import 'dart:convert';

import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/auth/models/user_model.dart';
import 'package:flutter/material.dart';
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
        saveUser(userModel!);
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

  void logout() {
    box.remove("userInfo");
    box.remove(isLogged);
    notifyListeners();
  }
}
