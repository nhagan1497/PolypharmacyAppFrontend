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
            clientId: "860620522800-ve1t836kbc94u32kpk1lfljj57171tf0.apps.googleusercontent.com",
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