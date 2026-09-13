import 'dart:convert';
import 'dart:io';
import 'package:deero_advert_app/core/app_error_handler.dart';
import 'package:deero_advert_app/core/constant.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/models/careers_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CareersProvider extends ChangeNotifier {
  // ── Careers state ─────────────────────────────────────────────────────────
  CareersModel? careersModel;
  bool isLoading = false;
  String? error;

  // ── Application state ─────────────────────────────────────────────────────
  bool isSubmitting = false;
  String? submitError;

  // ── Fetch all careers ─────────────────────────────────────────────────────
  Future<void> getAllCareers() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await http.get(Uri.parse(EndPoint + "careers/active"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        careersModel = CareersModel.fromJson(data);
      } else {
        error = AppErrorHandler.fromStatusCode(response.statusCode);
      }
    } catch (e) {
      error = AppErrorHandler.toFriendlyMessage(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Submit job application ─────────────────────────────────────────────────
  Future<bool> submitApplication({
    required String fullName,
    required String position,
    required String phone,
    required String email,
    String? careerId,
    String? portfolioUrl,
    required File cvFile,
    File? portfolioFile,
    File? certificateFile,
  }) async {
    try {
      isSubmitting = true;
      submitError = null;
      notifyListeners();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(EndPoint + "applications"),
      );

      request.fields['fullName'] = fullName;
      request.fields['position'] = position;
      request.fields['phone'] = phone;
      request.fields['email'] = email;
      if (careerId != null) {
        request.fields['careerId'] = careerId;
      }
      if (portfolioUrl != null && portfolioUrl.isNotEmpty) {
        request.fields['portfolioUrl'] = portfolioUrl;
      }

      // CV — required
      request.files.add(
        await http.MultipartFile.fromPath('cv', cvFile.path),
      );

      // Portfolio — optional
      if (portfolioFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('portfolio', portfolioFile.path),
        );
      }

      // Certificate — optional
      if (certificateFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('certificate', certificateFile.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Application Response [${response.statusCode}]: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        try {
          final data = jsonDecode(response.body);
          submitError = AppErrorHandler.toFriendlyMessage(data['message']);
        } catch (_) {
          submitError = AppErrorHandler.fromStatusCode(response.statusCode);
        }
        return false;
      }
    } catch (e) {
      submitError = AppErrorHandler.toFriendlyMessage(e);
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
