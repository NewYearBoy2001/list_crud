class UserArguments {
  int? id;
  String? name;
  String? email;
  String? gender;
  String? status;
  bool isEditMode;


  UserArguments({
    this.id,
    this.name,
    this.email,
    this.gender,
    this.status,
    required this.isEditMode,
  });
}
