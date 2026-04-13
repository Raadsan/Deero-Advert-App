class MajorClientModel {
  bool? success;
  List<MajorClient>? clients;

  MajorClientModel({this.success, this.clients});

  MajorClientModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['clients'] != null) {
      clients = <MajorClient>[];
      json['clients'].forEach((v) {
        clients!.add(MajorClient.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (clients != null) {
      data['clients'] = clients!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MajorClient {
  String? sId;
  String? description;
  List<String>? images;
  String? createdAt;
  String? updatedAt;

  MajorClient({
    this.sId,
    this.description,
    this.images,
    this.createdAt,
    this.updatedAt,
  });

  MajorClient.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    description = json['description'];
    if (json['images'] != null) {
      images = <String>[];
      json['images'].forEach((v) {
        if (v is String) {
          images!.add(v);
        } else if (v is Map) {
          final val = v['url'] ?? v['image'] ?? v['path'] ?? v['url_link'] ?? v['imagePath'] ?? v['type'] ?? v['img'];
          if (val != null) images!.add(val.toString());
        }
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['description'] = description;
    data['images'] = images;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
