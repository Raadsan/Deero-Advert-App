import 'dart:convert';

import 'package:deero_advert_app/core/constant.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/models/hosting_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HostingProvider extends ChangeNotifier {
  HostingModel? hostingModel;
  List<HostingModel> _listhosting = [];
  List<HostingModel> get listhosting => _listhosting;
  bool isLoading = false;
  String? error;

  Future<void> getAllHosting() async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await http.get(Uri.parse(EndPoint + "hosting"));
      if (response.statusCode == 200) {
        print("Worked");
        print("${response.statusCode}");
        print(response.body);
        final data = jsonDecode(response.body);
        hostingModel = HostingModel.fromJson(data);
      }
      print(hostingModel?.data?.length);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }
}
