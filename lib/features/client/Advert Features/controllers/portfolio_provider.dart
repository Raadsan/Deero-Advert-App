import 'dart:convert';

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
        error = "Failed to load portfolio. Status code: ${response.statusCode}";
      }
    } catch (e) {
      error = "Failed to load portfolio: $e";
    }
    isLoading = false;
    notifyListeners();
  }
}
