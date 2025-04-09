import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:list_crud/src/ui/user_arguments.dart';
import 'package:list_crud/src/ui/edit_user/edit_user_screen.dart';
import 'package:list_crud/src/ui/home/home_screen.dart';
import 'package:list_crud/src/ui/user_details_screen/view_user_screen.dart';

import '../src/ui/splash/splash_screen.dart';

class AppRouter {

  static final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        routes: <GoRoute>[

          /// Home Screen
          GoRoute(
              path: 'homeScreen',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const HomeScreen(),
                  transitionDuration: const Duration(milliseconds: 450),
                  transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child) {
                    return FadeTransition(
                      opacity: CurveTween(curve: Curves.easeIn).animate(animation),
                      child: child,
                    );
                  },
                );
              }),

          /// Edit Screen
          GoRoute(
              path: 'edit_screen',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: EditUserScreen(
                    editUserArguments: state.extra as UserArguments,
                  ),
                  transitionDuration: const Duration(milliseconds: 450),
                  transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child) {
                    return FadeTransition(
                      opacity:
                          CurveTween(curve: Curves.easeIn).animate(animation),
                      child: child,
                    );
                  },
                );
              }),


          /// User details screen
          GoRoute(
              path: 'details_screen',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return CustomTransitionPage<void>(
                  key: state.pageKey,
                  child:  UserDetailsScreen(
                    userArguments: state.extra as UserArguments,
                  ),
                  transitionDuration: const Duration(milliseconds: 450),
                  transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child) {
                    return FadeTransition(
                      opacity:
                      CurveTween(curve: Curves.easeIn).animate(animation),
                      child: child,
                    );
                  },
                );
              }),


        ],
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const SplashScreen(),
      ),
    ],
  );

  static GoRouter get router => _router;
}
