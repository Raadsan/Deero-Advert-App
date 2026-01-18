class ServiceModel {
  String? message;
  bool? success;
  List<Data>? data;
  int? count;

  ServiceModel({this.message, this.success, this.data, this.count});

  ServiceModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class Data {
  String? sId;
  String? serviceTitle;
  String? serviceIcon;
  List<Packages>? packages;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
      this.serviceTitle,
      this.serviceIcon,
      this.packages,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    serviceTitle = json['serviceTitle'];
    serviceIcon = json['serviceIcon'];
    if (json['packages'] != null) {
      packages = <Packages>[];
      json['packages'].forEach((v) {
        packages!.add(new Packages.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['serviceTitle'] = this.serviceTitle;
    data['serviceIcon'] = this.serviceIcon;
    if (this.packages != null) {
      data['packages'] = this.packages!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Packages {
  String? packageTitle;
  double? price;
  List<String>? features;
  String? sId;

  Packages({this.packageTitle, this.price, this.features, this.sId});

  Packages.fromJson(Map<String, dynamic> json) {
    packageTitle = json['packageTitle'];
    price = json['price'];
    features = json['features'].cast<String>();
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['packageTitle'] = this.packageTitle;
    data['price'] = this.price;
    data['features'] = this.features;
    data['_id'] = this.sId;
    return data;
  }
}
