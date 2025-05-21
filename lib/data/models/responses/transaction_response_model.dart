// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:minpa_lite/data/models/responses/product_response_model.dart';


class TransactionResponseModel {
  final List<TransactionModel>? data;

  TransactionResponseModel({
    this.data,
  });

  factory TransactionResponseModel.fromJson(String str) =>
      TransactionResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TransactionResponseModel.fromMap(Map<String, dynamic> json) =>
      TransactionResponseModel(
        data: json["data"] == null
            ? []
            : List<TransactionModel>.from(
                json["data"]!.map((x) => TransactionModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class TransactionModel {
  final int? id;
  final String? transactionId;
  final String? orderNumber;
  final int? outletId;
  final String? subTotal;
  final String? totalPrice;
  final int? totalItems;
  final String? tax;
  final String? discount;
  final String? paymentMethod;
  final String? status;
  final int? cashierId;
  final DateTime? createdAt;
  final List<Item>? items;

  TransactionModel({
    this.id,
    this.transactionId,
    this.orderNumber,
    this.outletId,
    this.subTotal,
    this.totalPrice,
    this.totalItems,
    this.tax,
    this.discount,
    this.paymentMethod,
    this.status,
    this.cashierId,
    this.createdAt,
    this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'orderNumber': orderNumber,
      'subTotal': subTotal,
      'totalPrice': totalPrice,
      'totalItems': totalItems,
      'tax': tax,
      'discount': discount,
      'paymentMethod': paymentMethod,
      'status': status,
      'cashierId': cashierId,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      transactionId: map['transactionId'],
      orderNumber: map['orderNumber'] == null ? '1' : map['orderNumber'],
      outletId: map['outletId'],
      subTotal: map['subTotal'],
      totalPrice: map['totalPrice'],
      totalItems: map['totalItems'],
      tax: map['tax'],
      discount: map['discount'],
      paymentMethod: map['paymentMethod'],
      status: map['status'],
      cashierId: map['cashierId'],
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  // to Backup
  Map<String, dynamic> toBackupMap() {
    return {
      'id': id,
      'transactionId': transactionId,
      'orderNumber': transactionId,
      'subTotal': subTotal,
      'totalPrice': totalPrice,
      'totalItems': totalItems,
      'tax': tax,
      'discount': discount,
      'paymentMethod': paymentMethod,
      'status': status,
      'cashierId': cashierId,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // to json
  String toJson() => json.encode(toBackupMap());

  // from json
  factory TransactionModel.fromJson(String str) =>
      TransactionModel.fromMap(json.decode(str));

  TransactionModel copyWith({
    int? id,
    String? transactionId,
    String? orderNumber,
    int? outletId,
    String? subTotal,
    String? totalPrice,
    int? totalItems,
    String? tax,
    String? discount,
    String? paymentMethod,
    String? status,
    int? cashierId,
    DateTime? createdAt,
    List<Item>? items,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      orderNumber: orderNumber ?? this.orderNumber,
      outletId: outletId ?? this.outletId,
      subTotal: subTotal ?? this.subTotal,
      totalPrice: totalPrice ?? this.totalPrice,
      totalItems: totalItems ?? this.totalItems,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      cashierId: cashierId ?? this.cashierId,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
    );
  }
}

class Item {
  final int? id;
  final String transactionItemId;
  final String? orderId; // foreign key ke transactions.id
  final String? productId; // foreign key ke products.id
  final int? quantity;
  final String? price;
  final String? total;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Product? product;

  Item({
    this.id,
    required this.transactionItemId,
    this.orderId,
    this.productId,
    this.quantity,
    this.price,
    this.total,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  Map<String, dynamic> toMap(String transaction) {
    return {
      'transactionItemId': transactionItemId,
      'orderId': transaction,
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'total': total,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toMap2() {
    return {
      'transactionItemId': transactionItemId,
      'orderId': orderId,
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'total': total,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      transactionItemId: map['transactionItemId'],
      orderId: map['orderId'],
      productId: map['productId'],
      quantity: map['quantity'],
      price: map['price'],
      total: map['total'],
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toBackupMap() {
    return {
      'id': id,
      'transactionItemId': transactionItemId,
      'orderId': orderId,
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'total': total,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // to json
  String toJson() => json.encode(toBackupMap());

  // from json
  factory Item.fromJson(String str) => Item.fromMap(json.decode(str));

  Item copyWith({
    int? id,
    String? transactionItemId,
    String? orderId,
    String? productId,
    int? quantity,
    String? price,
    String? total,
    DateTime? createdAt,
    DateTime? updatedAt,
    Product? product,
  }) {
    return Item(
      id: id ?? this.id,
      transactionItemId: transactionItemId ?? this.transactionItemId,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      product: product ?? this.product,
    );
  }
}
