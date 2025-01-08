// To parse this JSON data, do
//
//     final userCartProductModel = userCartProductModelFromJson(jsonString);

import 'dart:convert';

UserCartProductModel userCartProductModelFromJson(String str) => UserCartProductModel.fromJson(json.decode(str));

String userCartProductModelToJson(UserCartProductModel data) => json.encode(data.toJson());

class UserCartProductModel {
    String productId;
    String productName;
    int quantity;
    double pricePerUnit;
    List<dynamic> imageUrl;

    UserCartProductModel({
        required this.productId,
        required this.productName,
        required this.quantity,
        required this.pricePerUnit,
        required this.imageUrl,
    });

    factory UserCartProductModel.fromJson(Map<String, dynamic> json) => UserCartProductModel(
        productId: json["productId"],
        productName: json["productName"],
        quantity: json["quantity"],
        pricePerUnit: json["pricePerUnit"]?.toDouble(),
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "quantity": quantity,
        "pricePerUnit": pricePerUnit,
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
    };
}
