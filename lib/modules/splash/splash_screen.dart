import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wise_spend_app/core/const/key_sharePre.dart';
import 'package:wise_spend_app/core/services/share_preferences_service.dart';
import 'package:wise_spend_app/routers/router_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // ktra da dang nhap
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    if (isLoggedIn) {
      // da dangnhap => home
      Timer(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, RouterName.home);
      });
      return;
    }

    // chua =>
    String? isFirstString = SharePreferencesService.getString(
      KeySharepre.keyIsFirstTime,
    );
    Timer(const Duration(seconds: 1), () {
      if (isFirstString != null && isFirstString == '1') {
        Navigator.pushReplacementNamed(context, RouterName.lauch);
      } else {
        Navigator.pushReplacementNamed(context, RouterName.welcome);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff00D09E),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset('assets/images/logo.png')),
          Text(
            'WiseSpend',
            style: GoogleFonts.poppins(
              fontSize: 52.14,
              fontWeight: FontWeight.bold,
              color: Color(0xffFFFFFF),
            ),
          ),
        ],
      ),
    );
  }
}
