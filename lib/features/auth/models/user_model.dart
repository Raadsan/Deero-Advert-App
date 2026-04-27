class UserModel {
  String? message;
  String? token;
  User? user;

  UserModel({this.message, this.token, this.user});

  UserModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user?.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? fullname;
  String? email;
  String? phone;
  String? image;
  int? bonus;
  String? bonusStatus;
  String? registerSource;
  Role? role;

  User({
    this.id,
    this.fullname,
    this.email,
    this.phone,
    this.image,
    this.bonus,
    this.bonusStatus,
    this.registerSource,
    this.role,
    this.discounts,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = (json['id'] ?? json['_id'])?.toString();
    fullname = json['fullname'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    bonus = json['bonus'] is int
        ? json['bonus']
        : int.tryParse(json['bonus']?.toString() ?? "0") ?? 0;
    bonusStatus = json['bonusStatus'];
    registerSource = json['registerSource'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    if (json['bonusHistory'] != null) {
      bonusHistory = <BonusHistory>[];
      json['bonusHistory'].forEach((v) {
        bonusHistory?.add(new BonusHistory.fromJson(v));
      });
    }
    if (json['discounts'] != null) {
      discounts = <Discount>[];
      json['discounts'].forEach((v) {
        discounts?.add(new Discount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['bonus'] = this.bonus;
    data['bonusStatus'] = this.bonusStatus;
    data['registerSource'] = this.registerSource;
    if (this.role != null) {
      data['role'] = this.role?.toJson();
    }
    if (this.bonusHistory != null) {
      data['bonusHistory'] = this.bonusHistory?.map((v) => v.toJson()).toList();
    }
    if (this.discounts != null) {
      data['discounts'] = this.discounts?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  List<BonusHistory>? bonusHistory;
  List<Discount>? discounts;
}

class BonusHistory {
  int? id;
  int? userId;
  int? amount;
  String? reason;
  String? type;
  String? createdAt;

  BonusHistory({
    this.id,
    this.userId,
    this.amount,
    this.reason,
    this.type,
    this.createdAt,
  });

  BonusHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    userId = json['userId'] != null ? int.tryParse(json['userId'].toString()) : null;
    amount = json['amount'] != null ? int.tryParse(json['amount'].toString()) : null;
    reason = json['reason'];
    type = json['type'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['amount'] = this.amount;
    data['reason'] = this.reason;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class Role {
  String? sId;
  String? name;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? description;

  Role({
    this.sId,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.description,
  });

  Role.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['description'] = this.description;
    return data;
  }
}

class Discount {
  int? id;
  String? targetType;
  String? targetId;
  double? discountValue;
  String? discountType;
  String? status;

  Discount({
    this.id,
    this.targetType,
    this.targetId,
    this.discountValue,
    this.discountType,
    this.status,
  });

  Discount.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    targetType = json['targetType'];
    targetId = json['targetId'];
    discountValue = (json['discountValue'] as num?)?.toDouble();
    discountType = json['discountType'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['targetType'] = this.targetType;
    data['targetId'] = this.targetId;
    data['discountValue'] = this.discountValue;
    data['discountType'] = this.discountType;
    data['status'] = this.status;
    return data;
  }
}

