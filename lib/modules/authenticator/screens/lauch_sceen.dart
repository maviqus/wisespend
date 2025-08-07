import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wise_spend_app/core/const/key_share_pref.dart';
import 'package:wise_spend_app/core/widgets/button_text_widget.dart';
import 'package:wise_spend_app/routers/router_name.dart';

class LauchSceen extends StatefulWidget {
  const LauchSceen({super.key});

  @override
  State<LauchSceen> createState() => _LauchSceenState();
}

class _LauchSceenState extends State<LauchSceen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('first_launch') ?? true;
    final token = prefs.getString(KeySharePref.keyTokenUser);

    if (isFirstLaunch) {
      await prefs.setBool('first_launch', false);
    }

    Future.delayed(const Duration(seconds: 3), () {
      if (token != null) {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouterName.home,
          (route) => false,
        );
      } else {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouterName.signin,
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    void goToSignIn() {
      Navigator.pushNamed(context, RouterName.signin);
    }

    void goToSignUp() {
      Navigator.pushNamed(context, RouterName.signup);
    }

    void goToForgotPassword() {
      Navigator.pushNamed(context, RouterName.forgotPassword);
    }

    return Scaffold(
      backgroundColor: const Color(0xffF1FFF3),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              color: const Color(0xff00D09E),
            ),
          ),
          SizedBox(height: 30.22.h),
          Text(
            'WiseSpend',
            style: GoogleFonts.poppins(
              fontSize: 52.14,
              fontWeight: FontWeight.w600,
              color: const Color(0xff00D09E),
            ),
          ),
          SizedBox(height: 53.h),
          ButtonTextWidget(
            text: 'Sign In',
            color: const Color(0xff00D09E),
            radius: 30,
            width: 207.w,
            height: 45.h,
            onTap: goToSignIn,
            textStyle: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff093030),
            ),
          ),
          SizedBox(height: 12.h),
          ButtonTextWidget(
            text: 'Sign Up',
            color: const Color(0xffDFF7E2),
            radius: 30,
            width: 207.w,
            height: 45.h,
            onTap: goToSignUp,
            textStyle: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff093030),
            ),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: goToForgotPassword,
            child: Text(
              'Forgot Password?',
              style: GoogleFonts.leagueSpartan(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff093030),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
