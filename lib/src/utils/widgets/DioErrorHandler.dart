import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:list_crud/src/constants/colors.dart';
import 'package:list_crud/src/model/state_model.dart';
import 'package:list_crud/src/utils/data/object_factory.dart';
import 'package:list_crud/src/utils/navigation_services.dart';

class DioErrorHandler {
  static StateModel<T> handle<T>(DioException e) {
    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;
    final message = _extractErrorMessage(responseData);

    String errorMsg;

    switch (statusCode) {
      case 400:
        errorMsg = message ?? "Bad request. Please try again.";
        break;
      case 401:
        _performLogout();
        errorMsg = message ?? "Invalid credential. Please try again.";
        break;
      case 403:
        errorMsg = message ?? "Access denied.";
        break;
      case 404:
        errorMsg = message ?? "Requested resource not found.";
        break;
      case 422:
        errorMsg = message ?? "Validation error. Please check your input.";
        break;
      case 429:
        errorMsg = "To many Request , Please Try again !";
        break;
      case 500:
        errorMsg = message ?? "Server error. Please try again later.";
        break;
      case 508:
        errorMsg = "Resource limit is reached. Please try again later.";
        break;
      default:
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            errorMsg = "Request timed out. Check your internet connection.";
            break;
          case DioExceptionType.connectionError:
            errorMsg = "Could not connect to server. Check your connection.";
            break;
          case DioExceptionType.cancel:
            errorMsg = "Request cancelled.";
            break;
          case DioExceptionType.unknown:
          default:
            errorMsg = "Something went wrong: ${e.message}";
        }
    }

    Fluttertoast.showToast(
      msg: errorMsg,
      gravity: ToastGravity.BOTTOM,
      textColor: AppColors.primaryWhiteColor,
    );

    return StateModel.error(errorMsg);
  }

  static String? _extractErrorMessage(dynamic responseData) {
    try {
      if (responseData == null) return null;

      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('message')) return responseData['message'];
        if (responseData.containsKey('error')) return responseData['error'];
      }

      return responseData.toString();
    } catch (_) {
      return null;
    }
  }

  static void _performLogout() async {
    // await ObjectFactory().prefs.clearPrefs();
    ObjectFactory().prefs.setIsLoggedIn(false);
    navigatorKey.currentContext?.pushReplacement('/login_screen');
  }
}
