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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.transactions != null) {
      data['transactions'] = this.transactions!.map((v) => v.toJson()).toList();
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
  });

  Transactions.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    hostingPackage = json['hostingPackage'] != null
        ? new HostingPackage.fromJson(json['hostingPackage'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.hostingPackage != null) {
      data['hostingPackage'] = this.hostingPackage!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['type'] = this.type;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['currency'] = this.currency;
    data['description'] = this.description;
    data['paymentMethod'] = this.paymentMethod;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['paymentReferenceId'] = this.paymentReferenceId;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['price'] = this.price;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    return data;
  }
}
