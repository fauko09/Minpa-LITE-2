import 'dart:convert';

class UserModel {
  final int? id;
  final String userId;
  final String name;
  final String phone;
  final String email;
  final String password;
  final String role;

  UserModel({
    this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      userId: map['userId'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userId': userId,
      'phone': phone,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  Map<String, dynamic> toBackupMap() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'phone': phone,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  // to json
  String toJson() => json.encode(toBackupMap());

  // from json
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
