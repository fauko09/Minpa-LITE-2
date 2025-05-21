// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ProductResponseModel {
  final List<Product>? data;

  ProductResponseModel({
    this.data,
  });

  factory ProductResponseModel.fromJson(String str) =>
      ProductResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductResponseModel.fromMap(Map<String, dynamic> json) =>
      ProductResponseModel(
        data: json["data"] == null
            ? []
            : List<Product>.from(json["data"]!.map((x) => Product.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Product {
  final int? id;
  final String? name;
  final String productId;
  final String? categoryId; // foreign key ke Category
  final String? description;
  final String? image;
  final String? color;
  final String? price;
  final String? cost;
  final int? stock;
  final String? barcode;
  final String? sku;
  // final List<Stock>? stocks;

  Product({
    this.id,
    this.name,
    required this.productId,
    this.categoryId,
    this.description,
    this.image,
    this.color,
    this.price,
    this.cost,
    this.stock,
    this.barcode,
    this.sku,
    // this.stocks,
  });

  // to Json
  String toJson() => json.encode(toBackupMap());

  // from json
  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'name': name,
      'productId': productId,
      'categoryId': categoryId,
      'description': description,
      'image': image,
      'color': color,
      'price': price,
      'cost': cost,
      'stock': stock,
      'barcode': barcode,
      'sku': sku,
    };
  }

  Map<String, dynamic> toBackupMap() {
    return {
      'id': id,
      'name': name,
      'productId': productId,
      'categoryId': categoryId,
      'description': description,
      'image': image,
      'color': color,
      'price': price,
      'cost': cost,
      'stock': stock,
      'barcode': barcode,
      'sku': sku,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      productId: map['productId'],
      categoryId: map['categoryId'],
      description: map['description'],
      image: map['image'],
      color: map['color'],
      price: map['price'],
      cost: map['cost'],
      stock: map['stock'],
      barcode: map['barcode'],
      sku: map['sku'],
    );
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.productId == productId &&
        other.categoryId == categoryId &&
        other.description == description &&
        other.image == image &&
        other.color == color &&
        other.price == price &&
        other.cost == cost &&
        other.stock == stock &&
        other.barcode == barcode &&
        other.sku == sku;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        productId.hashCode ^
        categoryId.hashCode ^
        description.hashCode ^
        image.hashCode ^
        color.hashCode ^
        price.hashCode ^
        cost.hashCode ^
        stock.hashCode ^
        barcode.hashCode ^
        sku.hashCode;
  }

  Product copyWith({
    int? id,
    String? name,
    String? productId,
    String? categoryId,
    String? description,
    String? image,
    String? color,
    String? price,
    String? cost,
    int? stock,
    String? barcode,
    String? sku,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      productId: productId ?? this.productId,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      image: image ?? this.image,
      color: color ?? this.color,
      price: price ?? this.price,
      cost: cost ?? this.cost,
      stock: stock ?? this.stock,
      barcode: barcode ?? this.barcode,
      sku: sku ?? this.sku,
    );
  }
}

// class Stock {
//   final int? id;
//   final int? productId;
//   final int? outletId;
//   final int? quantity;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final Outlet? outlet;
//   final Product? product;

//   Stock({
//     this.id,
//     this.productId,
//     this.outletId,
//     this.quantity,
//     this.createdAt,
//     this.updatedAt,
//     this.outlet,
//     this.product,
//   });

//   factory Stock.fromJson(String str) => Stock.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory Stock.fromMap(Map<String, dynamic> json) => Stock(
//         id: json["id"],
//         productId: json["product_id"] is int
//             ? json["product_id"]
//             : int.parse(json["product_id"]),
//         outletId: json["outlet_id"] is int
//             ? json["outlet_id"]
//             : int.parse(json["outlet_id"]),
//         quantity: json["quantity"] is int
//             ? json["quantity"]
//             : int.parse(json["quantity"]),
//         createdAt: json["created_at"] == null
//             ? null
//             : DateTime.parse(json["created_at"]),
//         updatedAt: json["updated_at"] == null
//             ? null
//             : DateTime.parse(json["updated_at"]),
//         outlet: json["outlet"] == null ? null : Outlet.fromMap(json["outlet"]),
//         product:
//             json["product"] == null ? null : Product.fromMap(json["product"]),
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "product_id": productId,
//         "outlet_id": outletId,
//         "quantity": quantity,
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//         "outlet": outlet?.toMap(),
//       };
// }
String colorToString(int color) {
  return color.toRadixString(16).padLeft(6, '0');
}
