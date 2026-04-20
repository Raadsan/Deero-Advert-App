class TransactionModel {
  bool? success;
  List<Transactions>? transactions;

  TransactionModel({this.success, this.transactions});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(Transactions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (transactions != null) {
      data['transactions'] = transactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transactions {
  String? sId;
  HostingPackage? hostingPackage;
  User? user;
  String? type;
  double? amount;
  String? status;
  String? currency;
  String? description;
  String? paymentMethod;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? paymentReferenceId;
  double? originalAmount;
  double? discountApplied;

  Transactions({
    this.sId,
    this.hostingPackage,
    this.user,
    this.type,
    this.amount,
    this.status,
    this.currency,
    this.description,
    this.paymentMethod,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.paymentReferenceId,
    this.originalAmount,
    this.discountApplied,
  });

  Transactions.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    hostingPackage = json['hostingPackage'] != null
        ? HostingPackage.fromJson(json['hostingPackage'])
        : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    type = json['type'];
    amount = json['amount']?.toDouble();
    status = json['status'];
    currency = json['currency'];
    description = json['description'];
    paymentMethod = json['paymentMethod'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    paymentReferenceId = json['paymentReferenceId'];
    originalAmount = json['originalAmount']?.toDouble();
    discountApplied = json['discountApplied']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (hostingPackage != null) {
      data['hostingPackage'] = hostingPackage!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['type'] = type;
    data['amount'] = amount;
    data['status'] = status;
    data['currency'] = currency;
    data['description'] = description;
    data['paymentMethod'] = paymentMethod;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['paymentReferenceId'] = paymentReferenceId;
    data['originalAmount'] = originalAmount;
    data['discountApplied'] = discountApplied;
    return data;
  }
}

class HostingPackage {
  String? sId;
  String? name;
  double? price;

  HostingPackage({this.sId, this.name, this.price});

  HostingPackage.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    price = json['price']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['price'] = price;
    return data;
  }
}

class User {
  String? sId;
  String? fullname;
  String? email;

  User({this.sId, this.fullname, this.email});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullname = json['fullname'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['fullname'] = fullname;
    data['email'] = email;
    return data;
  }
}
