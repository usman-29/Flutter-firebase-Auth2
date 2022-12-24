import 'package:flutter/material.dart';
import 'package:chat_app_project/auth.dart';
import 'package:chat_app_project/pages/home_page.dart';
import 'package:chat_app_project/pages/login_register_page.dart';

class AuthStatusPage extends StatefulWidget {
  const AuthStatusPage({super.key});

  @override
  State<AuthStatusPage> createState() => _AuthStatusPageState();
}

class _AuthStatusPageState extends State<AuthStatusPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: ((context, snapshot) {
        // if the user is logged in
        if (snapshot.hasData) {
          return HomePage();
        }

        // if the user is logged out
        else {
          return const LoginPage();
        }
      }),
    );
  }
}
