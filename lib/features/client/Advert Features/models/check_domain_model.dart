class DomainCheckResult {
  final String? sId;
  final String domain;
  final bool available;
  final String price;

  DomainCheckResult({
    this.sId,
    required this.domain,
    required this.available,
    required this.price,
  });

  factory DomainCheckResult.fromJson(Map<String, dynamic> json) {
    return DomainCheckResult(
      sId: json['_id'] ?? json['id'],
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
  final String? sId;
  final String tld;
  final double newPrice;
  final String duration;

  DomainPrice({
    this.sId,
    required this.tld,
    required this.newPrice,
    required this.duration,
  });

  factory DomainPrice.fromJson(Map<String, dynamic> json) {
    return DomainPrice(
      sId: json['_id'],
      tld: json['tld'],
      newPrice: (json['price'] as num).toDouble(),
      duration: json['duration'] ?? "1 Year",
    );
  }
}
