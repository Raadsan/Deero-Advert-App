import 'dart:convert';
import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/models/check_domain_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CheckDomainProvider extends ChangeNotifier {
  bool loading = false;
  String? error; // New error field
  List<DomainCheckResult> results = [];

  // Fetch domain prices from backend
  Future<List<DomainPrice>> _fetchAllDomainPrices() async {
    try {
      final response = await http.get(Uri.parse(EndPoint + "domain-prices"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return (data['prices'] as List)
              .map((e) => DomainPrice.fromJson(e))
              .toList();
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<void> checkDomain(String query) async {
    loading = true;
    error = null; // Clear previous error
    results.clear();
    notifyListeners();

    try {
      String domainToCheck = query.toLowerCase().trim();

      final allPrices = await _fetchAllDomainPrices();

      // Get TLD from domain
      double? foundPrice;
      String? domainId;
      if (domainToCheck.contains('.')) {
        final parts = domainToCheck.split('.');
        final tld = '.${parts.last}';

        for (var p in allPrices) {
          if (p.tld.toLowerCase() == tld.toLowerCase()) {
            foundPrice = p.newPrice;
            domainId = p.sId;
            print("Found TLD: ${p.tld}, Price: ${p.newPrice}, ID: ${p.sId}");
            break;
          }
        }
      }

      // If price not found, it means the extension doesn't exist in our list
      if (foundPrice == null) {
        print("TLD Price not found in backend for domain extensions.");
        error = "This domain extension does not exist in our system.";
        loading = false;
        notifyListeners();
        return;
      }

      final price = foundPrice;

      try {
        final response = await http.get(
          Uri.parse("https://rdap.org/domain/$domainToCheck"),
        );

        if (response.statusCode == 429) {
          results.add(
            DomainCheckResult(
              sId: domainId,
              domain: domainToCheck,
              available: true,
              price: "\$${price.toStringAsFixed(2)}/Year",
            ),
          );
        } else {
          results.add(
            DomainCheckResult(
              sId: domainId,
              domain: domainToCheck,
              available: response.statusCode == 404,
              price: "\$${price.toStringAsFixed(2)}/Year",
            ),
          );
        }
      } catch (_) {
        results.add(
          DomainCheckResult(
            sId: domainId,
            domain: domainToCheck,
            available: true,
            price: "\$${price.toStringAsFixed(2)}/Year",
          ),
        );
      }
    } catch (e) {
      error = "An unexpected error occurred.";
      results.clear();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
