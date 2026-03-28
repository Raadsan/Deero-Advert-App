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
    mainImage = json['mainImage'];
    description = json['description'];
    year = json['year'];
    industry = json['industry'];
    gallery = json['gallery'].cast<String>();
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
