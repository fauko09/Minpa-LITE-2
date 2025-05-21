import 'dart:convert';

class TaxDiscountModel {
  int? id;
  final String name;
  final String type;
  final int value;
  final String status;
  final String chargeType;

  TaxDiscountModel({
    this.id,
    required this.name,
    required this.type,
    required this.value,
    required this.status,
    required this.chargeType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'type': type,
      'status': status,
      'value': value,
      'chargeType': chargeType,
      // 'createdAt': createdAt?.millisecondsSinceEpoch,
      // 'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory TaxDiscountModel.fromLocalMap(Map<String, dynamic> json) =>
      TaxDiscountModel(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        status: json["status"],
        value: json["value"],
        chargeType: json["chargeType"],
      );

  // to backup map
  Map<String, dynamic> toBackupMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type,
      'status': status,
      'value': value,
      'chargeType': chargeType,
    };
  }

  // to json
  String toJson() => json.encode(toBackupMap());

  // from json
  factory TaxDiscountModel.fromJson(String str) =>
      TaxDiscountModel.fromLocalMap(json.decode(str));
}
