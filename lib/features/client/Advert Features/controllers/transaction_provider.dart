import 'dart:convert';

import 'package:deero_enterprise_app/core/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TransactionProvider extends ChangeNotifier {
  bool isLoading = false;

  Future<bool> CreateTransaction({
    String? domainId,
    dynamic domain, // Use dynamic to handle potential object change
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
        "domain": domain,
        "serviceId": serviceId,
        "packageId": packageId,
        "hostingPackageId": hostingPackageId,
        "userId": userId,
        "amount": amount,
        "description": description,
        "accountNo": accountNo,
        "paymentMethod": paymentMethod,
      };

      print("Sending Transaction Data: ${jsonEncode(data)}");

      var response = await http.post(
        Uri.parse(EndPoint + "transactions"),
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );

      var decodedResponse = jsonDecode(response.body);
      print("Backend Response: $decodedResponse");

      if (response.statusCode == 200 || decodedResponse['success'] == true) {
        isSuccess = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              decodedResponse['message'] ?? "Transaction successful",
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        isSuccess = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(decodedResponse['message'] ?? "Transaction failed"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error creating transaction: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return isSuccess;
  }
}
