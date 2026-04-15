import 'dart:convert';

import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class TransactionProvider extends ChangeNotifier {
  bool isLoading = false;
  String errorMessage = "";
  TransactionModel? transactionModel;

  Future<TransactionModel?> getTransactionHistoryByUserId(String userId) async {
    try {
      isLoading = true;
      errorMessage = "";
      notifyListeners();

      final box = GetStorage();
      final userInfo = box.read("userInfo");
      final token = userInfo != null ? userInfo["token"] : null;

      var response = await http.get(
        Uri.parse(EndPoint + "transactions/user/$userId"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      var decodedData = jsonDecode(response.body);
      print("Backend Response: $decodedData");

      if (response.statusCode == 200 || decodedData['success'] == true) {
        transactionModel = TransactionModel.fromJson(decodedData);
      } else {
        final raw = decodedData['message']?.toString() ?? "";
        errorMessage = _friendlyTransactionError(raw, response.statusCode);
      }
    } catch (e) {
      print("Error getting transaction history: $e");
      errorMessage = _friendlyTransactionError(e.toString(), null);
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return transactionModel;
  }

  /// User-facing copy (avoid raw "No token" from API).
  static String _friendlyTransactionError(String raw, int? status) {
    final s = raw.toLowerCase();
    final auth =
        status == 401 ||
        s.contains("no token") ||
        s.contains("unauthorized") ||
        s.contains("invalid signature") ||
        s.contains("jsonwebtoken") ||
        s.contains("jwt");
    if (auth) {
      return "LOGIN_REQUIRED";
    }
    if (raw.isEmpty) return "Failed to load transaction history";
    return raw;
  }

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
        "description": description ?? "Deero Services Payment",
        "accountNo": accountNo,
        "paymentMethod": paymentMethod,
      };

      print("Sending Transaction Data: ${jsonEncode(data)}");

      final box = GetStorage();
      final userInfo = box.read("userInfo");
      final token = userInfo != null ? userInfo["token"] : null;

      var response = await http.post(
        Uri.parse(EndPoint + "transactions"),
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      var decodedResponse = jsonDecode(response.body);
      print("Backend Response: $decodedResponse");

      if (response.statusCode == 200 || decodedResponse['success'] == true) {
        isSuccess = true;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                decodedResponse['message'] ?? "Transaction successful",
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        isSuccess = false;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(decodedResponse['message'] ?? "Transaction failed"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print("Error creating transaction: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return isSuccess;
  }
}
