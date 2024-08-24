import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:polypharmacy/ui/login/blue_box_decoration.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            height: 220, // Reduced height for the header
            padding: const EdgeInsets.all(16), // Reduced padding
            decoration: blueBoxDecoration,
            child: Column(
              children: [
                const SizedBox(height: 48), // Reduced space
                Text(
                  "Polypharmacy",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4), // Reduced space between text and icon
                const Icon(
                  Icons.medication_outlined, // "prescription" icon
                  color: Colors.white,
                  size: 64,
                ),
              ],
            ),
          ),
          // Sign-in screen
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 120.0),
                child: SignInScreen(
                  resizeToAvoidBottomInset: false,
                  showPasswordVisibilityToggle: true,
                  providers: [
                    EmailAuthProvider(),
                    GoogleProvider(
                      clientId:
                      "27887611849-6smoqgqfo2im4svkkuvakegbs52v51eb.apps.googleusercontent.com",
                      iOSPreferPlist: true,
                    ),
                  ],
                  subtitleBuilder: (context, action) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0), // Reduced padding
                      child: action == AuthAction.signIn
                          ? const Text('Welcome to Polypharmacy, please sign in!')
                          : const Text('Welcome to Polypharmacy, please sign up!'),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,  // Set a fixed height for the bottom bar
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: blueBoxDecoration,
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
    );
  }
}
