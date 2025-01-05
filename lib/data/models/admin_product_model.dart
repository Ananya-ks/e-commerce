// To parse this JSON data, do
//
//     final adminProdcutModel = adminProdcutModelFromJson(jsonString);

import 'dart:convert';

AdminProdcutModel adminProdcutModelFromJson(String str) =>
    AdminProdcutModel.fromJson(json.decode(str));

String adminProdcutModelToJson(AdminProdcutModel data) =>
    json.encode(data.toJson());

class AdminProdcutModel {
  // CreatedAt createdAt;
  String productDesc;
  String productId;
  String productName;
  double productPrice;
  int productQuantity;
  List<dynamic> productUrls;

  AdminProdcutModel({
    // required this.createdAt,
    required this.productDesc,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productQuantity,
    required this.productUrls,
  });

  factory AdminProdcutModel.fromJson(Map<String, dynamic> json) =>
      AdminProdcutModel(
        // createdAt: CreatedAt.fromJson(json["created_at"]),
        productDesc: json["product_desc"],
        productId: json["product_id"],
        productName: json["product_name"],
        productPrice: json["product_price"],
        productQuantity: json["product_quantity"],
        productUrls: List<String>.from(json["product_urls"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        // "created_at": createdAt.toJson(),
        "product_desc": productDesc,
        "product_id": productId,
        "product_name": productName,
        "product_price": productPrice,
        "product_quantity": productQuantity,
        "product_urls": List<dynamic>.from(productUrls.map((x) => x)),
      };
}

// class CreatedAt {
//   int seconds;
//   int nanoseconds;

//   CreatedAt({
//     required this.seconds,
//     required this.nanoseconds,
//   });

//   factory CreatedAt.fromJson(Map<String, dynamic> json) => CreatedAt(
//         seconds: json["_seconds"],
//         nanoseconds: json["_nanoseconds"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_seconds": seconds,
//         "_nanoseconds": nanoseconds,
//       };
// }
