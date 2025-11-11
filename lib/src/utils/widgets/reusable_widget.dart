import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:list_crud/src/constants/assets.dart';
import 'package:list_crud/src/utils/data/object_factory.dart';
import 'package:lottie/lottie.dart';

class NoDataWidget extends StatelessWidget {
  final String message;

  const NoDataWidget({super.key, this.message = "No Data"});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            Assets.NO_DATA,
            height: 300,
            width: 300,
          ),
          // const SizedBox(height: 20),
          Text(
            message,
            style: GoogleFonts.roboto(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// LOGOUT
class LogoutHandler {
  static void logout(BuildContext context) {
    // Clear login flags
    ObjectFactory().prefs.clearPrefs();

    ObjectFactory().prefs.setIsLoggedIn(false);

    // Navigate to login screen
    context.pushReplacement('/login_screen');

    // Optional: Log out message
    debugPrint('User logged out');
  }
}


/// Screen Error
class ErrorWidgetLottie extends StatelessWidget {
  final String message;
  final double height;
  final double width;

  const ErrorWidgetLottie({
    super.key,
    this.message = "Something went wrong",
    this.height = 200,
    this.width = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            "ghhjn",
            height: height,
            width: width,
          ),
          // const SizedBox(height: 12),
          Text(
            message,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}



/// LOADING

class LoadingWidgetLottie extends StatelessWidget {
  final double height;
  final double width;

  const LoadingWidgetLottie({
    super.key,
    this.height = 60,
    this.width = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        Assets.JUMBINGDOT,
        height: height,
        width: width,
      ),
    );
  }
}
