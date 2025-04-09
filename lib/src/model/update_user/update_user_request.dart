// To parse this JSON data, do
//
//     final updateUserRequest = updateUserRequestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UpdateUserRequest updateUserRequestFromJson(String str) => UpdateUserRequest.fromJson(json.decode(str));

String updateUserRequestToJson(UpdateUserRequest data) => json.encode(data.toJson());

class UpdateUserRequest {
  String name;
  String email;
  String gender;
  String status;

  UpdateUserRequest({
    required this.name,
    required this.email,
    required this.gender,
    required this.status,
  });

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) => UpdateUserRequest(
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
