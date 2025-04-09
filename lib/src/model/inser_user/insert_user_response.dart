// To parse this JSON data, do
//
//     final insertUserResponse = insertUserResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

InsertUserResponse insertUserResponseFromJson(String str) => InsertUserResponse.fromJson(json.decode(str));

String insertUserResponseToJson(InsertUserResponse data) => json.encode(data.toJson());

class InsertUserResponse {
  int id;
  String name;
  String email;
  String gender;
  String status;

  InsertUserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.status,
  });

  factory InsertUserResponse.fromJson(Map<String, dynamic> json) => InsertUserResponse(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    gender: json["gender"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "gender": gender,
    "status": status,
  };
}
