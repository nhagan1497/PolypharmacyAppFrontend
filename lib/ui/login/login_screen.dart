import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Sign-in screen
          Expanded(
            child: SignInScreen(
              providers: [
                EmailAuthProvider(),
                GoogleProvider(
                  clientId:
                  "27887611849-6smoqgqfo2im4svkkuvakegbs52v51eb.apps.googleusercontent.com",
                  iOSPreferPlist: true,
                ),
              ],
              headerMaxExtent: 180,
              headerBuilder: (context, constraints, _) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.blue[900]!,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        "Polypharmacy",
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8), // Space between text and icon
                      const Icon(
                        Icons.medication_outlined, // "prescription" icon
                        color: Colors.white,
                        size: 64,
                      ),
                    ],
                  ),
                );
              },
              subtitleBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: action == AuthAction.signIn
                      ? const Text('Welcome to Polypharmacy, please sign in!')
                      : const Text('Welcome to Polypharmacy, please sign up!'),
                );
              },
            ),
          ),
          // Gradient container below the sign-in screen
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.blue[900]!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Powered by Flutter",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8), // Space between text and icon
                  FlutterLogo(
                    size: 24, // Adjust the size as needed
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
