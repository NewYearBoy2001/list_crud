import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../utils/network_connectivity/bloc/network_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 3;

  _loadWidget() async {
    var duration = Duration(seconds: splashDelay);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    context.go('/homeScreen');
  }


  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkBloc, NetworkState>(
      builder: (context, state) {
        if (state is NetworkSuccess) {
          return Material(
            color: AppColors.primaryBlueColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SvgPicture.asset(
                    Assets.SPLASH_LOGO,
                    fit: BoxFit.contain,
                    height: 150,
                    width: 150,
                  )
                      .animate()
                      .fadeIn(
                    duration: const Duration(milliseconds: 900),
                  )
                      .slideX(
                      duration: const Duration(
                        milliseconds: 500,
                      ),
                      curve: Curves.easeIn)
                      .then()
                      .shimmer(duration: const Duration(milliseconds: 800)),
                ),
              ],
            ),
          );
        } else if (state is NetworkFailure || state is NetworkInitial) {
          return Material(
            color: AppColors.primaryWhiteColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(Assets.NO_INTERNET),
                  Text(
                    "Your not connected to the internet",
                    style: GoogleFonts.openSans(
                      color: AppColors.primaryRedColor,
                      fontSize: 20,
                    ),
                  ).animate().scale(delay: 200.ms, duration: 300.ms),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
