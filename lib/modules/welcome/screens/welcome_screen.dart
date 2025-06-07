import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wise_spend_app/routers/router_name.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _titles = [
    'Welcome to Expense Manager',
    '¿Are You Ready To Take Control Of Your Finances?',
  ];

  final List<String> _images = [
    'assets/images/coins_hand.png',
    'assets/images/phone_hand.png',
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _titles.length - 1) {
        setState(() {
          _currentPage++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        timer.cancel();
      }
    });
  }

  void _nextPage() {
    if (_currentPage < _titles.length - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushNamed(context, RouterName.lauch);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00D09E),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 123),
          Text(
            _titles[_currentPage],
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 30.sp,
              color: const Color(0xff0E3E3E),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 63.h),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xffF1FFF3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: PageView.builder(
                controller: _pageController,
                itemCount: _titles.length,
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: Image.asset(
                          'assets/images/Ellipse 185.png',
                          height: 600.h,
                        ),
                      ),
                      Center(child: Image.asset(_images[index], height: 200.h)),
                    ],
                  );
                },
              ),
            ),
          ),
          Container(
            color: const Color(0xffF1FFF3),
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              children: [
                TextButton(
                  onPressed: _nextPage,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.w,
                      vertical: 15.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    "Next",
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      color: const Color(0xff0E3E3E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == 0
                            ? const Color(0xff00D09E)
                            : Colors.grey,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == 1
                            ? const Color(0xff00D09E)
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
