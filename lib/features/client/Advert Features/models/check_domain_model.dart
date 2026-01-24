class DomainCheckResult {
  final String domain;
  final bool available;
  final String price;

  DomainCheckResult({
    required this.domain,
    required this.available,
    required this.price,
  });

  factory DomainCheckResult.fromJson(Map<String, dynamic> json) {
    return DomainCheckResult(
      domain: json['domain'],
      available: json['available'],
      price: json['price'],
    );
  }
}

// class DomainCheckResponse {
//   final bool success;
//   final List<DomainCheckResult> results;

//   DomainCheckResponse({
//     required this.success,
//     required this.results,
//   });
// }

class DomainPrice {
  final String tld;
  final double newPrice;
  final String duration;

  DomainPrice({
    required this.tld,
    required this.newPrice,
    required this.duration,
  });

  factory DomainPrice.fromJson(Map<String, dynamic> json) {
    return DomainPrice(
      tld: json['tld'],
      newPrice: (json['newPrice'] as num).toDouble(),
      duration: json['duration'],
    );
  }
}
