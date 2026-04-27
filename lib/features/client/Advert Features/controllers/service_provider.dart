import 'dart:convert';

import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ServiceProvider extends ChangeNotifier {
  ServiceModel? serviceModel;
  List<ServiceModel> _listService = [];
  List<ServiceModel> get listService => _listService;
  bool isLoading = false;
  String? error;

  Future<void> getAllServices() async {
    try {
      isLoading = true;
      error = null; // Clear previous error
      notifyListeners();
      
      final response = await http.get(Uri.parse(EndPoint + "service"));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        serviceModel = ServiceModel.fromJson(data);
        error = null; // Clear error on success
      } else {
        error = "Failed to load services: ${response.statusCode}";
      }
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = "Connection error: ${e.toString()}";
      isLoading = false;
      notifyListeners();
    }
  }
}
