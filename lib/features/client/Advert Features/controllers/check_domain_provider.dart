import 'dart:convert';
import 'package:deero_advert_app/core/constant.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/models/check_domain_model.dart';
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
          return (data['data'] as List)
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
      String baseName = domainToCheck;
      if (domainToCheck.contains('.')) {
        baseName = domainToCheck.split('.').first;
      }

      List<DomainPrice> allPrices = await _fetchAllDomainPrices();

      if (allPrices.isEmpty) {
        error = "No domain extensions found in the server. Please add them in your Admin Panel.";
        loading = false;
        notifyListeners();
        return;
      }

      List<Future<void>> checks = [];

      for (var p in allPrices) {
        checks.add(
          (() async {
            String tld = p.tld.toLowerCase();
            if (!tld.startsWith('.')) tld = '.$tld';
            String fullDomain = "$baseName$tld";
            double price = p.newPrice;

            try {
              final rdapUrl = _getRDAPUrl(fullDomain);
              final response = await http.get(Uri.parse(rdapUrl));

              if (response.statusCode == 200) {
                // Domain exists (Taken)
                results.add(
                  DomainCheckResult(
                    sId: p.sId,
                    domain: fullDomain,
                    available: false,
                    price: "\$${price % 1 == 0 ? price.toInt() : price.toStringAsFixed(2)}/Year",
                  ),
                );
              } else if (response.statusCode == 404) {
                // Domain not found (Available)
                results.add(
                  DomainCheckResult(
                    sId: p.sId,
                    domain: fullDomain,
                    available: true,
                    price: "\$${price % 1 == 0 ? price.toInt() : price.toStringAsFixed(2)}/Year",
                  ),
                );
              } else {
                // Rate limit or server error
                results.add(
                  DomainCheckResult(
                    sId: p.sId,
                    domain: fullDomain,
                    available: false, // Default to false if we can't be sure
                    price: "\$${price % 1 == 0 ? price.toInt() : price.toStringAsFixed(2)}/Year",
                  ),
                );
              }
            } catch (e) {
              results.add(
                DomainCheckResult(
                  sId: p.sId,
                  domain: fullDomain,
                  available: false,
                  price: "\$${price % 1 == 0 ? price.toInt() : price.toStringAsFixed(2)}/Year",
                ),
              );
            }
          })(),
        );
      }

      await Future.wait(checks);

      // Sort: show available domains first, then by domain name length/alphabet
      results.sort((a, b) {
        if (a.available == b.available) {
          return a.domain.compareTo(b.domain);
        }
        return a.available ? -1 : 1;
      });
    } catch (e) {
      error = "An unexpected error occurred.";
      results.clear();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  String _getRDAPUrl(String domain) {
    if (domain.endsWith(".so")) {
      return "https://rdap.nic.so/domain/$domain";
    } else if (domain.endsWith(".com") || domain.endsWith(".net")) {
      return "https://rdap.verisign.com/com/v1/domain/$domain";
    } else if (domain.endsWith(".org")) {
      return "https://rdap.pir.org/domain/$domain";
    } else if (domain.endsWith(".edu")) {
      return "https://rdap.educause.edu/domain/$domain";
    } else {
      return "https://rdap.org/domain/$domain";
    }
  }
}
