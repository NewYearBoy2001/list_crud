part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

/// List
class UserListEvent extends UserEvent {
  final int page;
  final int perPage;
  const UserListEvent({required this.page, required this.perPage});

  @override
  List<Object> get props => [page, perPage];
}


/// Insert user
class InsertUserEvent extends UserEvent{
  final InsertUserRequest insertUserRequest;
  const InsertUserEvent({required this.insertUserRequest});
  @override
  List<Object?> get props => [insertUserRequest,];
}

/// Update user
class UpdateUserEvent extends UserEvent {
  final int id;
  final UpdateUserRequest updateUserRequest;
  const UpdateUserEvent({required this.id, required this.updateUserRequest});
  @override
  List<Object> get props => [id, updateUserRequest];
}


/// Details user
class UserDetailsEvent extends UserEvent {
  final int id;
  const UserDetailsEvent({required this.id});
  @override
  List<Object> get props => [id];
}

/// Delete user
class DeleteUserEvent extends UserEvent {
  final int id;
  const DeleteUserEvent({required this.id});
  @override
  List<Object> get props => [id];
}

