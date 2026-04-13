import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/models/major_client_model.dart';

class MajorClientProvider extends ChangeNotifier {
  MajorClientModel? majorClientModel;
  bool isLoading = false;
  String errorMessage = "";

  Future<void> getMajorClients() async {
    try {
      isLoading = true;
      errorMessage = "";
      notifyListeners();

      final response = await http.get(Uri.parse("${EndPoint}majorclients"));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        majorClientModel = MajorClientModel.fromJson(decodedData);
      } else {
        errorMessage = "Failed to load major clients: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage = "Error fetching major clients: $e";
      print(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
