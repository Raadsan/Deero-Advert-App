import 'dart:convert';
import 'package:deero_advert_app/core/constant.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/models/testimonial_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TestimonialProvider extends ChangeNotifier {
  TestimonialModel? _testimonialModel;
  bool _isLoading = false;
  String _error = "";

  TestimonialModel? get testimonialModel => _testimonialModel;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> getTestimonials() async {
    _isLoading = true;
    _error = "";
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('${EndPoint}testimonials'));

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);

        // Backend may return a plain list or an object with a "testimonials" key
        List<dynamic> list;
        if (decoded is List) {
          list = decoded;
        } else if (decoded is Map<String, dynamic>) {
          list = decoded['testimonials'] ?? decoded['data'] ?? [];
        } else {
          list = [];
        }

        _testimonialModel = TestimonialModel(
          success: true,
          testimonials: list.map((e) => Testimonial.fromJson(e)).toList(),
        );
      } else {
        _error = "Failed to load testimonials. Status code: ${response.statusCode}";
      }
    } catch (e) {
      _error = "An error occurred: $e";
    }

    _isLoading = false;
    notifyListeners();
  }
}
