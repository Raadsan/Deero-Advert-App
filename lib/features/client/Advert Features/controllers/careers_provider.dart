import 'dart:convert';
import 'package:deero_advert_app/core/constant.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/models/careers_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CareersProvider extends ChangeNotifier {
  CareersModel? careersModel;
  bool isLoading = false;
  String? error;

  Future<void> getAllCareers() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await http.get(Uri.parse(EndPoint + "careers"));

      if (response.statusCode == 200) {
        print("Careers Response Status: ${response.statusCode}");
        final data = jsonDecode(response.body);
        careersModel = CareersModel.fromJson(data);
      } else {
        error = "Failed to load careers. Status code: ${response.statusCode}";
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }
}
