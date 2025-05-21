// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StoreModel {
  final int? id;
  final String name;
  final String address;

  StoreModel({
    this.id,
    required this.name,
    required this.address,
  });

  factory StoreModel.fromMap(Map<String, dynamic> map) {
    return StoreModel(
      id: map['id'],
      name: map['name'],
      address: map['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
    };
  }

  String toJson() => json.encode(toMap());

  factory StoreModel.fromJson(String source) =>
      StoreModel.fromMap(json.decode(source));
}
