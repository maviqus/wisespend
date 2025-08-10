import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wise_spend_app/core/app/index.dart';
import 'package:wise_spend_app/core/services/firebase_service.dart';
import 'package:wise_spend_app/core/services/share_preferences_service.dart';
import 'package:wise_spend_app/firebase_options.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await SharePreferencesService.init();

    await FirebaseService.init();

    runApp(const Index());
  } catch (e, _) {
    // Show a minimal error UI instead of print
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'App Initialization Error',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  e.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
