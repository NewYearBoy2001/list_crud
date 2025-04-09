// user_list_response.dart
import 'dart:convert';

List<UserListResponse> userListResponseFromJson(String str) =>
    List<UserListResponse>.from(json.decode(str).map((x) => UserListResponse.fromJson(x)));

String userListResponseToJson(List<UserListResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserListResponse {
  final int id;
  final String name;
  final String email;
  final Gender gender;
  final Status status;

  UserListResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.status,
  });

  factory UserListResponse.fromJson(Map<String, dynamic> json) => UserListResponse(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    gender: genderValues.map[json["gender"].toLowerCase()]!,
    status: statusValues.map[json["status"].toLowerCase()]!,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "gender": genderValues.reverse[gender],
    "status": statusValues.reverse[status],
  };
}

enum Gender { FEMALE, MALE }

final genderValues = EnumValues({
  "female": Gender.FEMALE,
  "male": Gender.MALE,
});

enum Status { ACTIVE, INACTIVE }

final statusValues = EnumValues({
  "active": Status.ACTIVE,
  "inactive": Status.INACTIVE,
});

class EnumValues<T> {
  final Map<String, T> map;
  late final Map<T, String> reverseMap;

  EnumValues(this.map) {
    reverseMap = map.map((k, v) => MapEntry(v, k));
  }

  Map<T, String> get reverse => reverseMap;
}
