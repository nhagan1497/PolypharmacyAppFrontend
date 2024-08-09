import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polypharmacy/repos/polypharmacy_repo.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final polypharmacyRepo = ref.watch(polypharmacyRepoProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You signed in!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20), // Add some spacing
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
              },
              child: const Text('Sign Out'),
            ),
            ElevatedButton(
                onPressed: polypharmacyRepo.fetchSecureData,
                child: const Text('Get Secure Data'))
          ],
        ),
      ),
    );
  }
}
