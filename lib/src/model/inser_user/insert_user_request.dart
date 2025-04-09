// To parse this JSON data, do
//
//     final insertUserRequest = insertUserRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

InsertUserRequest insertUserRequestFromJson(String str) => InsertUserRequest.fromJson(json.decode(str));

String insertUserRequestToJson(InsertUserRequest data) => json.encode(data.toJson());

class InsertUserRequest {
  String name;
  String email;
  String gender;
  String status;

  InsertUserRequest({
    required this.name,
    required this.email,
    required this.gender,
    required this.status,
  });

  factory InsertUserRequest.fromJson(Map<String, dynamic> json) => InsertUserRequest(
    name: json["name"],
    email: json["email"],
    gender: json["gender"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "gender": gender,
    "status": status,
  };
}
