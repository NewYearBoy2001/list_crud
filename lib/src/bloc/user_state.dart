part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
}

final class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

/// List

final class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoaded extends UserState {
  final List<UserListResponse> userListResponse;
  const UserLoaded({required this.userListResponse});
  @override
  List<Object> get props => [userListResponse];
}


class UserLoadingError extends UserState {
  final String errorMsg;
  const UserLoadingError({required this.errorMsg});
  @override
  List<Object> get props => [];
}

class UserLoadingRequestResourceNotFound extends UserState {
  final String errorMsg;
  const UserLoadingRequestResourceNotFound({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

class UserLoadingConnectionRefused extends UserState {
  final String errorMsg;
  const UserLoadingConnectionRefused({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

/// insert
final class InsertUserLoading extends UserState {
  @override
  List<Object> get props => [];
}

class InsertUserLoaded extends UserState {
  final InsertUserResponse insertUserResponse;
  const InsertUserLoaded({required this.insertUserResponse});
  @override
  List<Object> get props => [insertUserResponse];
}


class InsertUserLoadingError extends UserState {
  final String errorMsg;
  const InsertUserLoadingError({required this.errorMsg});
  @override
  List<Object> get props => [];
}

class InsertUserLoadingResourceNotFound extends UserState {
  final String errorMsg;
  const InsertUserLoadingResourceNotFound({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

class InsertUserLoadingConnectionRefused extends UserState {
  final String errorMsg;
  const InsertUserLoadingConnectionRefused({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}



/// Update
final class UpdateUserLoading extends UserState {
  @override
  List<Object> get props => [];
}

class UpdateUserLoaded extends UserState {
  final UpdateUserResponse updateUserResponse;
  const UpdateUserLoaded({required this.updateUserResponse});
  @override
  List<Object> get props => [updateUserResponse];
}


class UpdateUserLoadingError extends UserState {
  final String errorMsg;
  const UpdateUserLoadingError({required this.errorMsg});
  @override
  List<Object> get props => [];
}

class UpdateUserLoadingResourceNotFound extends UserState {
  final String errorMsg;
  const UpdateUserLoadingResourceNotFound({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

class UpdateUserLoadingConnectionRefused extends UserState {
  final String errorMsg;
  const UpdateUserLoadingConnectionRefused({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}


/// Delete
final class DeleteUserLoading extends UserState {
  @override
  List<Object> get props => [];
}

class DeleteUserLoaded extends UserState {
  final String message;
  const DeleteUserLoaded({required this.message});
  @override
  List<Object> get props => [message];
}

class DeleteUserLoadingError extends UserState {
  final String errorMsg;
  const DeleteUserLoadingError({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

class DeleteUserLoadingResourceNotFound extends UserState {
  final String errorMsg;
  const DeleteUserLoadingResourceNotFound({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

class DeleteUserLoadingConnectionRefused extends UserState {
  final String errorMsg;
  const DeleteUserLoadingConnectionRefused({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}


/// Details user
final class UserDetailsLoading extends UserState {
  @override
  List<Object> get props => [];
}

class UserDetailsLoaded extends UserState {
  final UserDetailsResponse userDetailsResponse;
  const UserDetailsLoaded({required this.userDetailsResponse});
  @override
  List<Object> get props => [userDetailsResponse];
}

class UserDetailsLoadingError extends UserState {
  final String errorMsg;
  const UserDetailsLoadingError({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

class UserDetailsLoadingResourceNotFound extends UserState {
  final String errorMsg;
  const UserDetailsLoadingResourceNotFound({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

class UserDetailsConnectionRefused extends UserState {
  final String errorMsg;
  const UserDetailsConnectionRefused({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
