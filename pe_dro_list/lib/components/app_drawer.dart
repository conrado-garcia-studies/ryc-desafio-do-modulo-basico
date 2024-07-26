import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth_provider.dart';
import 'package:shop/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Pe Dro List'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.moped_outlined),
            title: const Text('Home'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(AppRoutes.authOrHome),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('about'),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.about),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              final AuthProvider authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );
              authProvider.logOut();
              Navigator.of(context).pushReplacementNamed(AppRoutes.authOrHome);
            },
          ),
        ],
      ),
    );
  }
}
