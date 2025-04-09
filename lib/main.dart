
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:list_crud/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ///setting Overlay
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light));

  ///setting device orientation as portrait, then calling the runApp method
  SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]).then((_) {
    runApp(
      const App(),
    );
  });
}