class ActiveNotificationModel {
  bool? success;
  List<Data>? data;

  ActiveNotificationModel({this.success, this.data});

  ActiveNotificationModel.fromJson(Map<String, dynamic> json) {
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
  String? title;
  String? message;
  String? linkUrl;
  String? startDate;
  String? endDate;
  String? createdBy;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.sId,
      this.title,
      this.message,
      this.linkUrl,
      this.startDate,
      this.endDate,
      this.createdBy,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    message = json['message'];
    linkUrl = json['linkUrl'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['message'] = this.message;
    data['linkUrl'] = this.linkUrl;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['createdBy'] = this.createdBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
