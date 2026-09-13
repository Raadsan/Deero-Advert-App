import 'dart:convert';

import 'package:deero_advert_app/core/app_error_handler.dart';
import 'package:deero_advert_app/core/constant.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/models/news_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsProvider extends ChangeNotifier {
  NewsModel? newsModel;
  bool isLoading = false;
  String? error;

  Future<void> getAllNews() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await http.get(Uri.parse(EndPoint + "events-news"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        newsModel = NewsModel.fromJson(data);
        error = null;
      } else {
        error = AppErrorHandler.fromStatusCode(response.statusCode);
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = AppErrorHandler.toFriendlyMessage(e);
      isLoading = false;
      notifyListeners();
    }
  }
}
