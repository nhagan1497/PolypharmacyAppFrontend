import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:polypharmacy/ui/login/blue_box_decoration.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: blueBoxDecoration,
        ),
        toolbarHeight: 160, // Set the height similar to your previous header
        centerTitle: true,
        title: Column(
          children: [
            const SizedBox(height: 16), // Adjust vertical spacing
            Text(
              "Polypharmacy",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 4), // Space between text and icon
            const Icon(
              Icons.medication_outlined,
              color: Colors.white,
              size: 64,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Sign-in screen
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 42.0),
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
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: action == AuthAction.signIn
                            ? const Text(
                            'Welcome to Polypharmacy, please sign in!')
                            : const Text(
                            'Welcome to Polypharmacy, please sign up!'),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60, // Set a fixed height for the bottom bar
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
