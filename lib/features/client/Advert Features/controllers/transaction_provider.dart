import 'dart:convert';

import 'package:deero_enterprise_app/core/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TransactionProvider extends ChangeNotifier {
  bool isLoading = false;

  Future<bool> CreateTransaction({
    String? domainId,
    String? serviceId,
    String? packageId,
    String? hostingPackageId,
    required String userId,
    required double amount,
    String? description,
    String? accountNo,
    String? paymentMethod,
    required BuildContext context,
  }) async {
    bool isSuccess = false;
    try {
      isLoading = true;
      notifyListeners();
      var data = {
        "domainId": domainId,
        "serviceId": serviceId,
        "packageId": packageId,
        "hostingPackageId": hostingPackageId,
        "userId": userId,
        "amount": amount,
        "description": description,
        "accountNo": accountNo,
        "paymentMethod": paymentMethod,
      };
      var response = await http.post(
        Uri.parse(EndPoint + "transactions"),
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );
      String responseBody = response.body;
      Map<String, dynamic> decodedResponse = {};
      try {
        decodedResponse = jsonDecode(responseBody);
      } catch (e) {
        print("Error decoding response: $e");
      }

      String userMessage =
          decodedResponse['responseMsg'] ??
          decodedResponse['message'] ??
          responseBody;

      if (response.statusCode == 200) {
        
        if (userMessage.toLowerCase().contains("failed")) { 
          isSuccess = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(userMessage), backgroundColor: Colors.red),
          );
        } else {
          isSuccess = true;
          print("Transaction created successfully");
        }
      } else {
        print("Failed to create transaction: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userMessage), backgroundColor: Colors.red),
        );
        isSuccess = false;
      }
    } catch (e) {
      print("Error creating transaction: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return isSuccess;
  }
}
