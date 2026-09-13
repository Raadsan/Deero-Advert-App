import 'dart:convert';
import 'package:deero_advert_app/core/app_error_handler.dart';
import 'package:deero_advert_app/core/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CompanyContact {
  final int id;
  final String type;
  final String value;

  CompanyContact({required this.id, required this.type, required this.value});

  factory CompanyContact.fromJson(Map<String, dynamic> json) {
    return CompanyContact(
      id: json['id'],
      type: json['type'],
      value: json['value'],
    );
  }
}

class CompanyContactProvider with ChangeNotifier {
  List<CompanyContact> _contacts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CompanyContact> get contacts => _contacts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchContacts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse("${EndPoint}company-contact"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          _contacts = (data['data'] as List)
              .map((item) => CompanyContact.fromJson(item))
              .toList();
        } else {
          _errorMessage = AppErrorHandler.toFriendlyMessage(data['message']);
        }
      } else {
        _errorMessage = AppErrorHandler.fromStatusCode(response.statusCode);
      }
    } catch (e) {
      _errorMessage = AppErrorHandler.toFriendlyMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String? getValueByType(String type) {
    final matches = _contacts
        .where((c) => c.type.toLowerCase() == type.toLowerCase())
        .map((c) => c.value)
        .toList();
    return matches.isEmpty ? null : matches.join('\n');
  }
}
