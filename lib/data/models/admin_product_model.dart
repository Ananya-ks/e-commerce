// To parse this JSON data, do
//
//     final adminProdcutModel = adminProdcutModelFromJson(jsonString);

import 'dart:convert';

AdminProdcutModel adminProdcutModelFromJson(String str) =>
    AdminProdcutModel.fromJson(json.decode(str));

String adminProdcutModelToJson(AdminProdcutModel data) =>
    json.encode(data.toJson());

class AdminProdcutModel {
  String productDesc;
  String productId;
  String productName;
  double productPrice;
  int productQuantity;
  List<dynamic> productUrls;

  AdminProdcutModel({
    required this.productDesc,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productQuantity,
    required this.productUrls,
  });

  factory AdminProdcutModel.fromJson(Map<String, dynamic> json) =>
      AdminProdcutModel(
        productDesc: json["product_desc"],
        productId: json["product_id"],
        productName: json["product_name"],
        productPrice: json["product_price"],
        productQuantity: json["product_quantity"],
        productUrls: List<String>.from(json["product_urls"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "product_desc": productDesc,
        "product_id": productId,
        "product_name": productName,
        "product_price": productPrice,
        "product_quantity": productQuantity,
        "product_urls": List<dynamic>.from(productUrls.map((x) => x)),
      };
}

