class HostingModel {
  bool? success;
  List<Data>? data;

  HostingModel({this.success, this.data});

  HostingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? name;
  String? desc;
  double? price;
  String? pudgeText;
  List<String>? features;
  String? createdAt;
  int? iV;

  Data(
      {this.sId,
      this.name,
      this.desc,
      this.price,
      this.pudgeText,
      this.features,
      this.createdAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    desc = json['desc'];
    price = json['price'];
    pudgeText = json['pudgeText'];
    features = json['features'].cast<String>();
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['desc'] = this.desc;
    data['price'] = this.price;
    data['pudgeText'] = this.pudgeText;
    data['features'] = this.features;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}
