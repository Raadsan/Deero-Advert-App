class AchievementModel {
  bool? success;
  String? message;
  List<Achievement>? data;
  int? count;

  AchievementModel({this.success, this.message, this.data, this.count});

  AchievementModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    count = json['count'];
    if (json['data'] != null) {
      data = <Achievement>[];
      json['data'].forEach((v) {
        data!.add(Achievement.fromJson(v));
      });
    }
  }
}

class Achievement {
  String? sId;
  String? title;
  int? count;
  String? icon;

  Achievement({this.sId, this.title, this.count, this.icon});

  Achievement.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    count = json['count'];
    icon = json['icon'];
  }
}
