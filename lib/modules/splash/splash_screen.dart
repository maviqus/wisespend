import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wise_spend_app/core/const/key_share_pref.dart';
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
    final isLoggedIn = prefs.getString(KeySharePref.keyTokenUser) ?? '';
    if (isLoggedIn.isNotEmpty) {
      // da dangnhap => home
      Timer(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, RouterName.home);
      });
      return;
    }

    // chua dang nhap => signin
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, RouterName.signin);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00D09E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Wise Spend',
              style: GoogleFonts.poppins(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.h),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
