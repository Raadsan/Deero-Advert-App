import 'dart:convert';
import 'package:deero_advert_app/core/app_error_handler.dart';
import 'package:deero_advert_app/core/constant.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/models/achievement_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AchievementProvider extends ChangeNotifier {
  AchievementModel? achievementModel;
  bool isLoading = false;
  String error = "";

  Future<void> getAchievements() async {
    isLoading = true;
    error = "";
    notifyListeners();

    try {
      final response = await http.get(Uri.parse("${EndPoint}achievements"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          achievementModel = AchievementModel.fromJson(data);
        } else {
          error = AppErrorHandler.toFriendlyMessage(data['message']);
        }
      } else {
        error = AppErrorHandler.fromStatusCode(response.statusCode);
      }
    } catch (e) {
      error = AppErrorHandler.toFriendlyMessage(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
