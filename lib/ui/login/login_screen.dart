import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInScreen(
        providers: [
          EmailAuthProvider(),
          GoogleProvider(
            clientId:
                "27887611849-6smoqgqfo2im4svkkuvakegbs52v51eb.apps.googleusercontent.com",
            iOSPreferPlist: true,
          ),
        ],
        headerBuilder: (context, constraints, shrinkOffset) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                "Polypharmacy",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
