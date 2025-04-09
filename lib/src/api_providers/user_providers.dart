import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:list_crud/src/model/inser_user/insert_user_request.dart';
import 'package:list_crud/src/model/inser_user/insert_user_response.dart';
import 'package:list_crud/src/model/state_model.dart';
import 'package:list_crud/src/model/update_user/update_user_request.dart';
import 'package:list_crud/src/model/update_user/update_user_response.dart';
import 'package:list_crud/src/model/user_details/user_details_response.dart';
import 'package:list_crud/src/model/user_list_response/user_list_response.dart';
import 'package:list_crud/src/utils/data/object_factory.dart';

class UserProvider {
  /// List
  Future<StateModel?> userListProvider(int page, int perPage) async {
    try {
      final response = await ObjectFactory().apiClient.listUser(page, perPage);
      print(" response: ${response.data}");

      if (response.statusCode == 200) {
        if (response.data is List) {
          return StateModel<List<UserListResponse>>.success(
            (response.data as List)
                .map((e) => UserListResponse.fromJson(e))
                .toList(),
          );
        }

        final decoded = jsonDecode(response.data);
        if (decoded is List) {
          return StateModel<List<UserListResponse>>.success(
            decoded.map((e) => UserListResponse.fromJson(e)).toList(),
          );
        }
      }

      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 500) {
        return StateModel.error(
            "The server isn't responding! Please try again later.");
      } else if (e.response != null && e.response!.statusCode == 408) {
        return StateModel.error(
            "Request timed out. Please try again later.");
      } else if (e.type == DioExceptionType.connectionError) {
        return StateModel.error(
            "Connection error. Please check your network and try again.");
      }
    }
    return null;
  }

  /// INSERT USER
  Future<StateModel?> insertUserProvider(InsertUserRequest insertUserRequest) async {
    try {
      final response = await ObjectFactory().apiClient.insertUserClient(insertUserRequest);
      print(response.toString());
      if (response.statusCode == 201) {
        return StateModel<InsertUserResponse>.success(
            InsertUserResponse.fromJson(response.data));
      } else {
        return null;
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 500) {
        return StateModel.error(
            "The server isn't responding! Please try again later.");
      } else if (e.response != null && e.response!.statusCode == 422) {
        return StateModel.error(
            "Unprocessable Entity!,Try again");
      } else if (e.response != null && e.type == DioExceptionType.connectionError) {
        return StateModel.error(
            "Connection refused. This indicates an error which most likely cannot be solved by the library. Please try again later or reach out to our support team for assistance. Thank you for your patience!");
      }
    }
    return null;
  }


  /// Update
  Future<StateModel?> updateUserProvider(int id,UpdateUserRequest updateUserRequest) async {
    try {
      final response = await ObjectFactory().apiClient.updateUserClient(id,updateUserRequest);
      print(response.toString());
      if (response.statusCode == 200) {
        return StateModel<UpdateUserResponse>.success(
            UpdateUserResponse.fromJson(response.data));
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 500) {
        return StateModel.error(
            "The server isn't responding! Please try again later.");
      } else if (e.response != null && e.response!.statusCode == 408) {
        return StateModel.error(
            "Request timed out. Please try again later.");
      } else if (e.type == DioExceptionType.connectionError) {
        return StateModel.error(
            "Connection error. Please check your network and try again.");
      }
    }
    return null;
  }


  /// Details
  Future<StateModel?> userDetailsProvider(int id) async {
    try {
      final response = await ObjectFactory().apiClient.userDetailsClient(id);
      print(" response: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is List) {
          return StateModel<List<UserDetailsResponse>>.success(
            data.map((e) => UserDetailsResponse.fromJson(e)).toList(),
          );
        } else if (data is Map<String, dynamic>) {
          return StateModel<UserDetailsResponse>.success(
            UserDetailsResponse.fromJson(data),
          );
        }
      }

      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 500) {
        return StateModel.error(
            "The server isn't responding! Please try again later.");
      } else if (e.response != null && e.response!.statusCode == 404) {
        return StateModel.error("Resource not found.");
      } else if (e.type == DioExceptionType.connectionError) {
        return StateModel.error(
            "Connection error. Please check your network and try again.");
      }
    }

    return null;
  }


  /// Delete
  Future<StateModel?> deleteUserProvider(int id) async {
    try {
      final response = await ObjectFactory().apiClient.deleteUserClient(id);
      print(response.toString());
      if (response.statusCode == 204) {
        return StateModel<String>.success("User deleted successfully");
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 500) {
        return StateModel.error(
            "The server isn't responding! Please try again later.");
      } else if (e.response != null && e.response!.statusCode == 404) {
        return StateModel.error(
            "Resource not found.");
      } else if (e.type == DioExceptionType.connectionError) {
        return StateModel.error(
            "Connection error. Please check your network and try again.");
      }
    }
    return null;
  }

}


