import 'dart:convert';

import 'package:deero_advert_app/core/app_error_handler.dart';
import 'package:deero_advert_app/core/constant.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/models/transaction_model.dart';
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
    return AppErrorHandler.toFriendlyMessage(raw);
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
    bool useBonus = false, // ✅ NEW: tells backend to reset bonus
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
        "useBonus": useBonus, // ✅ Send to backend for bonus reset
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

      dynamic decodedResponse;
      try {
        if (response.body.isNotEmpty && response.body.trim().startsWith('{')) {
          decodedResponse = jsonDecode(response.body);
        } else {
          decodedResponse = null;
        }
      } catch (_) {
        decodedResponse = null;
      }
      print("Backend Response: $decodedResponse");

      final isSuccessResponse = response.statusCode == 200 ||
          (decodedResponse is Map && decodedResponse['success'] == true);

      if (isSuccessResponse) {
        isSuccess = true;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                (decodedResponse is Map ? decodedResponse['message'] : null) ??
                    "Lacag bixintu si guul leh ayay u dhacday",
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        isSuccess = false;
        String failMsg = "Payment failed. Please try again.";
        if (decodedResponse is Map && decodedResponse['message'] != null) {
          failMsg = AppErrorHandler.toFriendlyMessage(decodedResponse['message']);
        } else if (response.statusCode == 404) {
          failMsg = "Payment service is currently unavailable.";
        } else if (response.statusCode >= 500) {
          failMsg = "Server error. Please try again later.";
        }
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failMsg),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Error creating transaction: $e");
      String cleanErr = AppErrorHandler.toFriendlyMessage(e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(cleanErr), backgroundColor: Colors.red),
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return isSuccess;
  }

  Future<Map<String, dynamic>> checkoutCart({
    required String userId,
    required String accountNo,
    required List<Map<String, dynamic>> items,
    String paymentMethod = "waafi",
  }) async {
    try {
      isLoading = true;
      errorMessage = "";
      notifyListeners();

      final box = GetStorage();
      final userInfo = box.read("userInfo");
      final token = userInfo != null ? userInfo["token"] : null;

      final payload = {
        "userId": userId,
        "accountNo": accountNo,
        "paymentMethod": paymentMethod,
        "items": items,
      };

      print("Sending Cart Checkout Payload: ${jsonEncode(payload)}");

      final response = await http.post(
        Uri.parse("${EndPoint}transactions/checkout"),
        body: jsonEncode(payload),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      dynamic decodedResponse;
      try {
        if (response.body.isNotEmpty && response.body.trim().startsWith('{')) {
          decodedResponse = jsonDecode(response.body);
        } else {
          decodedResponse = null;
        }
      } catch (_) {
        decodedResponse = null;
      }

      print("Cart Checkout Response: $decodedResponse");

      final isSuccess = response.statusCode == 200 ||
          (decodedResponse is Map && decodedResponse['success'] == true);

      if (isSuccess) {
        return {
          "success": true,
          "message": (decodedResponse is Map ? decodedResponse['message'] : null) ??
              "Payment completed successfully.",
          "data": decodedResponse,
        };
      } else {
        String failureMsg = "Payment failed. Please try again.";
        if (decodedResponse is Map && decodedResponse['message'] != null) {
          failureMsg = AppErrorHandler.toFriendlyMessage(decodedResponse['message']);
        } else if (response.statusCode == 404) {
          failureMsg = "Payment service is currently unavailable.";
        } else if (response.statusCode >= 500) {
          failureMsg = "Server error. Please try again later.";
        }
        return {
          "success": false,
          "message": failureMsg,
          "data": decodedResponse,
        };
      }
    } catch (e) {
      debugPrint("Error in cart checkout: $e");
      return {
        "success": false,
        "message": AppErrorHandler.toFriendlyMessage(e),
      };
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}


