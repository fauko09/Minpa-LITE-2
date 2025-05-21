// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class CategoryResponseModel {
  final List<CategoryModel>? data;

  CategoryResponseModel({
    this.data,
  });

  factory CategoryResponseModel.fromJson(String str) =>
      CategoryResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoryResponseModel.fromMap(Map<String, dynamic> json) =>
      CategoryResponseModel(
        data: json["data"] == null
            ? []
            : List<CategoryModel>.from(
                json["data"]!.map((x) => CategoryModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class CategoryModel {
  final int? id;
  final String? name;
  final String? categoryId;

  CategoryModel({
    this.id,
    this.name,
    this.categoryId,
  });

  // from map
  factory CategoryModel.fromMap(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],
        categoryId: json["categoryId"],
      );

  // to map
  Map<String, dynamic> toMap() => {
        "name": name,
        "categoryId": categoryId,
      };

  Map<String, dynamic> toBackupMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'categoryId': categoryId,
    };
  }

  String toJson() => json.encode(toBackupMap());

  // from json
  factory CategoryModel.fromJson(String str) =>
      CategoryModel.fromMap(json.decode(str));

  @override
  String toString() {
    return name ?? 'Kategori';
  }

  @override
  bool operator ==(covariant CategoryModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ categoryId.hashCode;
}
