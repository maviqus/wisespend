import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wise_spend_app/core/app/index.dart';
import 'package:wise_spend_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(Index());
}
