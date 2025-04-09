// To parse this JSON data, do
//
//     final updateUserResponse = updateUserResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UpdateUserResponse updateUserResponseFromJson(String str) => UpdateUserResponse.fromJson(json.decode(str));

String updateUserResponseToJson(UpdateUserResponse data) => json.encode(data.toJson());

class UpdateUserResponse {
  String email;
  String name;
  String gender;
  String status;
  int id;

  UpdateUserResponse({
    required this.email,
    required this.name,
    required this.gender,
    required this.status,
    required this.id,
  });

  factory UpdateUserResponse.fromJson(Map<String, dynamic> json) => UpdateUserResponse(
    email: json["email"],
    name: json["name"],
    gender: json["gender"],
    status: json["status"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "name": name,
    "gender": gender,
    "status": status,
    "id": id,
  };
}
