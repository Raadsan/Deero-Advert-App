class VideoModel {
  bool? success;
  String? message;
  List<VideoData>? data;

  VideoModel({this.success, this.message, this.data});

  VideoModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VideoData>[];
      if (json['data'] is List) {
        json['data'].forEach((v) {
          data!.add(VideoData.fromJson(v));
        });
      }
    }
  }
}

class VideoData {
  String? id;
  String? title;
  String? url;
  String? createdAt;

  VideoData({this.id, this.title, this.url, this.createdAt});

  VideoData.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id']?.toString();
    title = json['title'];
    url = json['url'];
    createdAt = json['createdAt'];
  }
}
