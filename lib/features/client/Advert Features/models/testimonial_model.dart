class TestimonialModel {
  bool? success;
  String? message;
  List<Testimonial>? testimonials;

  TestimonialModel({this.success, this.message, this.testimonials});

  TestimonialModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['testimonials'] != null) {
      testimonials = <Testimonial>[];
      json['testimonials'].forEach((v) {
        testimonials!.add(Testimonial.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (testimonials != null) {
      data['testimonials'] = testimonials!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Testimonial {
  int? id;
  String? clientName;
  String? clientTitle;
  String? clientImage;
  String? message;
  int? rating;
  String? createdAt;
  String? updatedAt;

  Testimonial(
      {this.id,
      this.clientName,
      this.clientTitle,
      this.clientImage,
      this.message,
      this.rating,
      this.createdAt,
      this.updatedAt});

  Testimonial.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id'].toString());
    clientName = json['clientName']?.toString();
    clientTitle = json['clientTitle']?.toString();
    clientImage = json['clientImage']?.toString();
    message = json['message']?.toString();
    rating = json['rating'] is int
        ? json['rating']
        : int.tryParse(json['rating'].toString()) ?? 5;
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['clientName'] = clientName;
    data['clientTitle'] = clientTitle;
    data['clientImage'] = clientImage;
    data['message'] = message;
    data['rating'] = rating;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
