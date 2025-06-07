import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wise_spend_app/routers/router_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      Navigator.pushNamed(context, RouterName.welcome);
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
