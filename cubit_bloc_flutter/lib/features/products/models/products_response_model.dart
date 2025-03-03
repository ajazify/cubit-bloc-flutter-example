// To parse this JSON data, do
//
//     final counterResponse = counterResponseFromJson(jsonString);

import 'dart:convert';

List<ProductsResponse> counterResponseFromJson(String str) =>
    List<ProductsResponse>.from(json.decode(str).map((x) => ProductsResponse.fromJson(x)));

String counterResponseToJson(List<ProductsResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductsResponse {
  int? id;
  String? title;
  double? price;
  String? description;
  String? category;
  String? image;
  Rating? rating;

  ProductsResponse({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.image,
    this.rating,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) => ProductsResponse(
        id: json["id"],
        title: json["title"],
        price: json["price"]?.toDouble(),
        description: json["description"],
        category: json["category"],
        image: json["image"],
        rating: json["rating"] == null ? null : Rating.fromJson(json["rating"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "description": description,
        "category": category,
        "image": image,
        "rating": rating?.toJson(),
      };
}

class Rating {
  double? rate;
  int? count;

  Rating({
    this.rate,
    this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rate: json["rate"]?.toDouble(),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "rate": rate,
        "count": count,
      };
}
