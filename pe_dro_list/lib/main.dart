import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/user.dart';
import 'package:shop/pages/about_screen.dart';
import 'package:shop/pages/auth_or_home_screen.dart';
import 'package:shop/providers/auth_provider.dart';
import 'package:shop/providers/home_provider.dart';
import 'package:shop/providers/user_provider.dart';
import 'package:shop/utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    _lockPortraitUpOrientation();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
          create: (_) => UserProvider(),
          update: (_, final AuthProvider authProvider,
              final UserProvider? previous) {
            final User? previousUser = previous?.user;
            final String? previousUserId = previousUser?.userId;
            return UserProvider(
              authProvider.userId ?? '',
              authProvider.token ?? '',
              previousUserId != null && authProvider.userId == previousUserId
                  ? previousUser
                  : null,
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(),
        ),
      ],
      child: MaterialApp(
        routes: {
          AppRoutes.about: (ctx) => const AboutScreen(),
          AppRoutes.authOrHome: (ctx) => const AuthOrHomeScreen(),
        },
        title: 'Pe Dro List',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color.fromRGBO(238, 53, 50, 1),
            secondary: const Color.fromRGBO(126, 126, 126, 1),
            tertiary: const Color.fromRGBO(224, 224, 224, 1),
          ),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'The Bold Font',
          textTheme: TextTheme(
            titleSmall: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  void _lockPortraitUpOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
}
