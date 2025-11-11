import 'package:dio/dio.dart';
import 'package:list_crud/src/model/inser_user/insert_user_request.dart';
import 'package:list_crud/src/model/inser_user/insert_user_response.dart';
import 'package:list_crud/src/model/state_model.dart';
import 'package:list_crud/src/model/update_user/update_user_request.dart';
import 'package:list_crud/src/model/update_user/update_user_response.dart';
import 'package:list_crud/src/model/user_details/user_details_response.dart';
import 'package:list_crud/src/model/user_list_response/user_list_response.dart';
import 'package:list_crud/src/utils/data/object_factory.dart';
import 'package:list_crud/src/utils/widgets/DioErrorHandler.dart';

class UserProvider {
  /// 🧾 User List
  Future<StateModel<List<UserListResponse>>?> userListProvider(
      int page, int perPage) async {
    try {
      final response =
      await ObjectFactory().apiClient.listUser(page, perPage);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data as Map<String, dynamic>)['data'] ?? [];

        final users =
        data.map((e) => UserListResponse.fromJson(e)).toList();

        return StateModel.success(users);
      } else {
        return StateModel.error(
            "Unexpected response: ${response.statusCode}");
      }
    } on DioException catch (e) {
      return DioErrorHandler.handle<List<UserListResponse>>(e);
    }
  }

  /// ➕ Insert User
  Future<StateModel<InsertUserResponse>?> insertUserProvider(
      InsertUserRequest insertUserRequest) async {
    try {
      final response = await ObjectFactory()
          .apiClient
          .insertUserClient(insertUserRequest);

      if (response.statusCode == 201) {
        return StateModel.success(
            InsertUserResponse.fromJson(response.data));
      } else {
        return StateModel.error(
            "Unexpected response: ${response.statusCode}");
      }
    } on DioException catch (e) {
      return DioErrorHandler.handle<InsertUserResponse>(e);
    }
  }

  /// ✏️ Update User
  Future<StateModel<UpdateUserResponse>?> updateUserProvider(
      int id, UpdateUserRequest updateUserRequest) async {
    try {
      final response = await ObjectFactory().apiClient.updateUserClient(id, updateUserRequest);

      if (response.statusCode == 200) {
        return StateModel.success(
            UpdateUserResponse.fromJson(response.data));
      } else {
        return StateModel.error(
            "Unexpected response: ${response.statusCode}");
      }
    } on DioException catch (e) {
      return DioErrorHandler.handle<UpdateUserResponse>(e);
    }
  }

  /// 👤 User Details
  Future<StateModel<UserDetailsResponse>?> userDetailsProvider(
      int id) async {
    try {
      final response = await ObjectFactory().apiClient.userDetailsClient(id);

      if (response.statusCode == 200) {
        return StateModel.success(
            UserDetailsResponse.fromJson(response.data));
      } else {
        return StateModel.error(
            "Unexpected response: ${response.statusCode}");
      }
    } on DioException catch (e) {
      return DioErrorHandler.handle<UserDetailsResponse>(e);
    }
  }

  /// ❌ Delete User
  Future<StateModel<String>?> deleteUserProvider(int id) async {
    try {
      final response = await ObjectFactory().apiClient.deleteUserClient(id);

      if (response.statusCode == 204) {
        return StateModel.success("User deleted successfully");
      } else {
        return StateModel.error(
            "Unexpected response: ${response.statusCode}");
      }
    } on DioException catch (e) {
      return DioErrorHandler.handle<String>(e);
    }
  }
}
