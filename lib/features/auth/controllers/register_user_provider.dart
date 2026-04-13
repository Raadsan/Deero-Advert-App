import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/auth/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:deero_enterprise_app/features/auth/controllers/user_provider.dart';

class RegisterUserProvider extends ChangeNotifier {
  UserModel? userModel;
  String? _fullname;
  String? _email;
  String? _phone;
  String? _password;

  String? get fullname => _fullname;
  String? get email => _email;
  String? get phone => _phone;
  String? get password => _password;

  void setName(String fullname) {
    _fullname = fullname;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  bool isLoading = false;
  String? registerError;

  Future<bool> register(BuildContext context) async {
    try {
      isLoading = true;
      registerError = null;
      notifyListeners();
      var data = {
        "fullname": fullname,
        "email": email,
        "password": password,
        "phone": phone,
        "role": "6953956770d76d4794728165",
        "registerSource": "mobile",
      };

      var response = await http.post(
        Uri.parse(EndPoint + "users"),
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Registration Success: ${response.statusCode}");

        final userProv = Provider.of<UserProvider>(context, listen: false);
        userProv.setEmail(email!);
        userProv.setPassword(password!);

        bool loginSuccess = await userProv.login(context);

        isLoading = false;
        notifyListeners();
        return loginSuccess;
      } else {
        registerError = "Invalid email or password";
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      registerError = "Connection error. Please try again.";
      isLoading = false;
      notifyListeners();
      print(e);
      return false;
    }
  }
}
