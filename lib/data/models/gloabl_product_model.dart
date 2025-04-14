// To parse this JSON data, do
//
//     final globalProductModel = globalProductModelFromJson(jsonString);

import 'dart:convert';

GlobalProductModel globalProductModelFromJson(String str) => GlobalProductModel.fromJson(json.decode(str));

String globalProductModelToJson(GlobalProductModel data) => json.encode(data.toJson());

class GlobalProductModel {
    String adminEmail;
    String productDesc;
    String productId;
    String productName;
    double productPrice;
    int productQuantity;
    List<dynamic> productUrls;

    GlobalProductModel({
        required this.adminEmail,
        required this.productDesc,
        required this.productId,
        required this.productName,
        required this.productPrice,
        required this.productQuantity,
        required this.productUrls,
    });

    factory GlobalProductModel.fromJson(Map<String, dynamic> json) => GlobalProductModel(
        adminEmail: json["admin_email"],
        productDesc: json["product_desc"],
        productId: json["product_id"],
        productName: json["product_name"],
        productPrice: json["product_price"],
        productQuantity: json["product_quantity"],
        productUrls: List<String>.from(json["product_urls"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "admin_email": adminEmail,
        "product_desc": productDesc,
        "product_id": productId,
        "product_name": productName,
        "product_price": productPrice,
        "product_quantity": productQuantity,
        "product_urls": List<dynamic>.from(productUrls.map((x) => x)),
    };
}
