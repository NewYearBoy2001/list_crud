import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// shared preference storage
class Prefs {
  JsonCodec codec = const JsonCodec();
  SharedPreferences? _sharedPreferences;

  static const String _AUTH_TOKEN = "auth_token";
  static const String _IS_LOGGED_IN = "is_logged_in";
  static const String _FCM_TOKEN = "fcm_token";
  static const String _USER_ID = "USER_ID";

  Prefs();

  set sharedPreferences(SharedPreferences value) {
    _sharedPreferences = value;
  }


  /// Auth Token
  void setAuthToken({String? accesstoken}) {
    _sharedPreferences!.setString(_AUTH_TOKEN, accesstoken ?? "");
  }

  String? getAuthToken() => _sharedPreferences!.getString(_AUTH_TOKEN);



  /// USER iD
  void setUserId({String? user_id}) {
    _sharedPreferences!.setString(_USER_ID, user_id ?? "");
  }

  String? getUseriD() => _sharedPreferences!.getString(_USER_ID);



  ///get method  for auth token
  String? getFcmToken() => _sharedPreferences!.getString(_FCM_TOKEN);


  void setFcmToken({String? fcmToken}) {
    _sharedPreferences!.setString(_FCM_TOKEN, fcmToken ?? "");
  }

  ///after login set isLoggedIn true
  ///before logout set isLoggedIn false
  void setIsLoggedIn(bool status) {
    _sharedPreferences!.setBool(_IS_LOGGED_IN, status);
  }

  bool? isLoggedIn() =>
      _sharedPreferences!.getBool(_IS_LOGGED_IN) != null &&
          _sharedPreferences!.getBool(_IS_LOGGED_IN) == true
          ? true
          : false;


  /// Clear all stored preferences
  Future<void> clearPrefs() async {
    await _sharedPreferences?.clear();
  }

}

