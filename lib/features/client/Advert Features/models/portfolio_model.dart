class PortfolioModel {
  bool? success;
  int? count;
  List<Portfolios>? portfolios;

  PortfolioModel({this.success, this.count, this.portfolios});

  PortfolioModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    count = json['count'];
    if (json['portfolios'] != null) {
      portfolios = <Portfolios>[];
      json['portfolios'].forEach((v) {
        portfolios!.add(Portfolios.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['count'] = this.count;
    if (this.portfolios != null) {
      data['portfolios'] = this.portfolios!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Portfolios {
  String? sId;
  String? title;
  String? mainImage;
  String? description;
  String? year;
  String? industry;
  List<String>? gallery;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Portfolios(
      {this.sId,
      this.title,
      this.mainImage,
      this.description,
      this.year,
      this.industry,
      this.gallery,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Portfolios.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    if (json['mainImage'] is String) {
      mainImage = json['mainImage'];
    } else if (json['mainImage'] is Map) {
      mainImage = json['mainImage']['url'] ??
          json['mainImage']['image'] ??
          json['mainImage']['path'];
    }
    description = json['description'];
    year = json['year'];
    industry = json['industry'];
    if (json['gallery'] != null) {
      gallery = <String>[];
      json['gallery'].forEach((v) {
        if (v is String) {
          gallery!.add(v);
        } else if (v is Map) {
          // Robustly handle if images are returned as objects
          final val = v['url'] ?? v['image'] ?? v['path'] ?? v['url_link'] ?? v['imagePath'];
          if (val != null) gallery!.add(val.toString());
        }
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['mainImage'] = this.mainImage;
    data['description'] = this.description;
    data['year'] = this.year;
    data['industry'] = this.industry;
    data['gallery'] = this.gallery;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
