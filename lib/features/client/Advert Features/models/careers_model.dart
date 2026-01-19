class CareersModel {
  String? message;
  bool? success;
  List<Data>? data;
  int? count;

  CareersModel({this.message, this.success, this.data, this.count});

  CareersModel.fromJson(Map<String, dynamic> json) {
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
  String? title;
  String? type;
  String? location;
  String? description;
  String? postedDate;
  String? expireDate;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? isActive;
  String? id;

  Data(
      {this.sId,
      this.title,
      this.type,
      this.location,
      this.description,
      this.postedDate,
      this.expireDate,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.isActive,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    type = json['type'];
    location = json['location'];
    description = json['description'];
    postedDate = json['postedDate'];
    expireDate = json['expireDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    isActive = json['isActive'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['type'] = this.type;
    data['location'] = this.location;
    data['description'] = this.description;
    data['postedDate'] = this.postedDate;
    data['expireDate'] = this.expireDate;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['isActive'] = this.isActive;
    data['id'] = this.id;
    return data;
  }
}
