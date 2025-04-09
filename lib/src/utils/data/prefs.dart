import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// shared preference storage
class Prefs {
  JsonCodec codec = const JsonCodec();
  SharedPreferences? _sharedPreferences;


  Prefs();

  set sharedPreferences(SharedPreferences value) {
    _sharedPreferences = value;
  }














}
