class CartItem {
  final String id;
  final String type; // 'domain', 'hosting', 'service'
  final String title;
  final String subtitle;
  final double price;
  final double? originalAmount;
  final double? discountApplied;
  final double? renewalPrice;
  final String? options;
  final String? serviceId;
  final String? packageId;
  final String? hostingPackageId;
  final Map<String, dynamic>? domainData;
  int quantity;

  CartItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.price,
    this.originalAmount,
    this.discountApplied,
    this.renewalPrice,
    this.options,
    this.serviceId,
    this.packageId,
    this.hostingPackageId,
    this.domainData,
    this.quantity = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'service',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalAmount: (json['originalAmount'] as num?)?.toDouble(),
      discountApplied: (json['discountApplied'] as num?)?.toDouble(),
      renewalPrice: (json['renewalPrice'] as num?)?.toDouble(),
      options: json['options']?.toString(),
      serviceId: json['serviceId']?.toString(),
      packageId: json['packageId']?.toString(),
      hostingPackageId: json['hostingPackageId']?.toString(),
      domainData: json['domainData'] != null
          ? Map<String, dynamic>.from(json['domainData'])
          : null,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'subtitle': subtitle,
      'price': price,
      'quantity': quantity,
      if (originalAmount != null) 'originalAmount': originalAmount,
      if (discountApplied != null) 'discountApplied': discountApplied,
      if (renewalPrice != null) 'renewalPrice': renewalPrice,
      if (options != null) 'options': options,
      if (serviceId != null) 'serviceId': serviceId,
      if (packageId != null) 'packageId': packageId,
      if (hostingPackageId != null) 'hostingPackageId': hostingPackageId,
      if (domainData != null) 'domainData': domainData,
    };
  }

  /// Format as payload for backend /api/transactions/checkout
  Map<String, dynamic> toCheckoutJson() {
    final Map<String, dynamic> map = {
      'type': type,
      'amount': price * quantity,
      'originalAmount': (originalAmount ?? price) * quantity,
      'discountApplied': (discountApplied ?? 0.0) * quantity,
      'quantity': quantity,
      'description': type == 'domain'
          ? 'Domain Registration: $subtitle'
          : 'Payment for $subtitle',
    };

    if (type == 'domain') {
      map['domain'] = domainData ?? {'name': subtitle, 'price': price};
    } else if (type == 'service') {
      map['serviceId'] = serviceId;
      map['packageId'] = packageId;
    } else if (type == 'hosting') {
      map['hostingPackageId'] = hostingPackageId;
    }

    return map;
  }
}
