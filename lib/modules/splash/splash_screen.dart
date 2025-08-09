import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wise_spend_app/core/const/key_share_pref.dart';
import 'package:wise_spend_app/routers/router_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Create fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start animation
    _animationController.forward();

    _navigate();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _navigationTimer?.cancel();
    super.dispose();
  }

  Future<void> _navigate() async {
    // ktra da dang nhap
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getString(KeySharePref.keyTokenUser) ?? '';
    if (isLoggedIn.isNotEmpty) {
      // da dangnhap => home
      _navigationTimer = Timer(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, RouterName.home);
        }
      });
      return;
    }

    // chua dang nhap => signin
    _navigationTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, RouterName.signin);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00D09E),
      body: Center(
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/icon slash.png',
                    width: 180.w,
                    height: 180.h,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
