import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_crud/src/api_providers/user_providers.dart';
import 'package:list_crud/src/bloc/user_bloc.dart';
import 'package:list_crud/src/utils/network_connectivity/bloc/network_bloc.dart';
import 'package:list_crud/src/utils/network_connectivity/network_helper.dart';
import 'package:overlay_support/overlay_support.dart';
import 'routes/router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MultiRepositoryProvider(
        providers: [

          RepositoryProvider(
            create: (create) => NetworkHelper(),
          ),

          RepositoryProvider(
            create: (create) => UserProvider(),
          ),

        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<NetworkBloc>(
              create: (BuildContext context) =>
              NetworkBloc()..add(NetworkObserve()),
            ),

            BlocProvider<UserBloc>(
              create: (BuildContext context) => UserBloc(
                userProvider: RepositoryProvider.of(context),
              ),
            ),
          ],
          child: MaterialApp.router(
            themeAnimationCurve: Curves.easeIn,
            themeAnimationDuration: const Duration(milliseconds: 750),
            routerDelegate: AppRouter.router.routerDelegate,
            routeInformationProvider: AppRouter.router.routeInformationProvider,
            routeInformationParser: AppRouter.router.routeInformationParser,
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.light,
            builder: (context, child) {
              final mediaQueryData = MediaQuery.of(context);
              return MediaQuery(
                data: mediaQueryData.copyWith(
                    textScaler: const TextScaler.linear(0.85)),
                child: child!,
              );
            },
          )
        ),
    )
    );
  }
}
