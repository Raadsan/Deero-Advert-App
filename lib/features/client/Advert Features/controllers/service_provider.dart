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
      notifyListeners();
      final response = await http.get(Uri.parse(EndPoint + "service"));
      if (response.statusCode == 200) {
        print("${response.statusCode}");
        print(response.body);
        final data = jsonDecode(response.body);
        serviceModel = ServiceModel.fromJson(data);
      }
      print(serviceModel?.data?.length);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }
}
