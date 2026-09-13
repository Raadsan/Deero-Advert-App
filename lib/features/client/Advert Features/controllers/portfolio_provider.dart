import 'dart:convert';

import 'package:deero_advert_app/core/app_error_handler.dart';
import 'package:deero_advert_app/core/constant.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/models/portfolio_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PortfolioProvider extends ChangeNotifier {
  PortfolioModel? portfolioModel;
  bool isLoading =false;
  String error = "";

  Future<void> getPortfolio() async {
    error = "";
    isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse(EndPoint + "portfolios"));
      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);
        portfolioModel = PortfolioModel.fromJson(decodeData);
      } else {
        error = AppErrorHandler.fromStatusCode(response.statusCode);
      }
    } catch (e) {
      error = AppErrorHandler.toFriendlyMessage(e);
    }
    isLoading = false;
    notifyListeners();
  }
}
