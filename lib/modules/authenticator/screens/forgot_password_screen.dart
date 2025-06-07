import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:wise_spend_app/core/widgets/button_text_filled_widget.dart';
import 'package:wise_spend_app/core/widgets/button_text_widget.dart';
import 'package:wise_spend_app/core/widgets/show_message_widget.dart';
import 'package:wise_spend_app/modules/authenticator/providers/forgot_password_provider.dart';
import 'package:wise_spend_app/routers/router_name.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00D09E),
      body: Column(
        children: [
          SizedBox(height: 100.h),
          Text(
            'Forgot Password',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 30.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff093030),
            ),
          ),
          SizedBox(height: 65.h),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xffF1FFF3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.r),
                  topRight: Radius.circular(50.r),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 34.w, vertical: 90.h),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Quên mật khẩu?',
                        style: GoogleFonts.poppins(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Đừng lo, chúng tôi sẽ giúp bạn đặt lại mật khẩu ngay.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 82.h),
                      Text(
                        'Nhập email của bạn',
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff093030),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      ButtonTextFilledWidget(
                        controller: _emailController,
                        hintText: 'example@gmail.com',
                        fillColor: const Color(0xffDFF7E2),
                        borderRadius: 18.r,
                        textStyle: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff093030),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 45.h),
                      Consumer<ForgotPasswordProvider>(
                        builder: (context, forgotPasswordProvider, _) {
                          return Center(
                            child: forgotPasswordProvider.isLoading
                                ? const CircularProgressIndicator()
                                : ButtonTextWidget(
                                    text: 'Next Step',
                                    color: const Color(0xff00D09E),
                                    width: 207.w,
                                    height: 45.h,
                                    radius: 30.r,
                                    onTap: () async {
                                      if (_formKey.currentState!.validate()) {
                                        final email = _emailController.text
                                            .trim();
                                        await forgotPasswordProvider
                                            .sendPasswordResetEmail(email);
                                        if (forgotPasswordProvider
                                                .errorMessage ==
                                            null) {
                                          ShowMessage(
                                            context: context,
                                            title:
                                                'Email đặt lại mật khẩu đã được gửi, hãy check mail nhé.',
                                            type: ToastificationType.success,
                                            alignment: Alignment.bottomCenter,
                                            duration: const Duration(
                                              seconds: 5,
                                            ),
                                          );
                                          Navigator.pushReplacementNamed(
                                            context,
                                            RouterName.signin,
                                          );
                                        } else {
                                          ShowMessage(
                                            context: context,
                                            title:
                                                'Failed to send reset email: ${forgotPasswordProvider.errorMessage}',
                                            type: ToastificationType.error,
                                            alignment: Alignment.bottomCenter,
                                            duration: const Duration(
                                              seconds: 5,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    textStyle: GoogleFonts.poppins(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          );
                        },
                      ),
                      SizedBox(height: 20.h),
                      Center(
                        child: ButtonTextWidget(
                          text: 'Sign Up',
                          color: const Color(0xffDFF7E2),
                          width: 207.w,
                          height: 45.h,
                          radius: 30.r,
                          onTap: () {
                            Navigator.pushNamed(context, RouterName.signup);
                          },
                          textStyle: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff093030),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff093030),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, RouterName.signup);
                            },
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff3299FF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
