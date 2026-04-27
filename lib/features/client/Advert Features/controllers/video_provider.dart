import 'dart:convert';
import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/models/video_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VideoProvider extends ChangeNotifier {
  VideoModel? videoModel;
  bool isLoading = false;
  String error = "";

  Future<void> getVideos() async {
    isLoading = true;
    error = "";
    notifyListeners();

    try {
      final response = await http.get(Uri.parse("${EndPoint}videos"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Backend might return a list or a wrapped object
        if (data is List) {
          videoModel = VideoModel(success: true, data: (data).map((e) => VideoData.fromJson(e)).toList());
        } else if (data['success'] == true || data.containsKey('title')) {
          videoModel = VideoModel.fromJson(data);
        } else {
          error = data['message'] ?? "Unknown error occurred";
        }
      } else {
        error = "Failed to load videos. Status: ${response.statusCode}";
      }
    } catch (e) {
      error = "Network Error: ${e.toString()}";
      print("Video fetch error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
