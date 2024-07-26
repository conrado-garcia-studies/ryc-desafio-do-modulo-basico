import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/auth_screen.dart';
import 'package:shop/pages/home_screen.dart';
import 'package:shop/providers/auth_provider.dart';

class AuthOrHomeScreen extends StatelessWidget {
  const AuthOrHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final AuthProvider authProvider = Provider.of(context);
    return FutureBuilder(
      future: authProvider.tryAutoLogIn(),
      builder: (_, final AsyncSnapshot<Object?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.error != null) {
          return const Center(
            child: Text('An error has occurred!'),
          );
        }
        return authProvider.isAuth ? const HomeScreen() : const AuthScreen();
      },
    );
  }
}
