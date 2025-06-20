import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:wise_spend_app/core/widgets/button_text_filled_widget.dart';
import 'package:wise_spend_app/core/widgets/button_text_widget.dart';
import 'package:wise_spend_app/core/widgets/show_message_widget.dart';
import 'package:wise_spend_app/modules/authenticator/providers/sign_up_provider.dart';
import 'package:wise_spend_app/routers/router_name.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpProvider(),
      child: const _SignUpScreenContent(),
    );
  }
}

class _SignUpScreenContent extends StatefulWidget {
  const _SignUpScreenContent();

  @override
  State<_SignUpScreenContent> createState() => _SignUpScreenContentState();
}

class _SignUpScreenContentState extends State<_SignUpScreenContent> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00D09E),
      body: Column(
        children: [
          SizedBox(height: 100.h),
          Text(
            'Create Account',
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
              decoration: BoxDecoration(
                color: const Color(0xffF1FFF3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.r),
                  topRight: Radius.circular(50.r),
                ),
              ),
              padding: EdgeInsets.all(20.w),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff093030),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      ButtonTextFilledWidget(
                        controller: usernameController,
                        hintText: 'Nhập username của bạn',
                        fillColor: const Color(0xffDFF7E2),
                        borderRadius: 18.r,
                        textStyle: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff093030),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập username của bạn';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Email',
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff093030),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      ButtonTextFilledWidget(
                        controller: emailController,
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
                            return 'Hãy nhập email của bạn';
                          }
                          if (!value.contains('@')) {
                            return 'Vui lòng nhập email hợp lệ';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Password',
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff093030),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      ButtonTextFilledWidget(
                        controller: passwordController,
                        hintText: '••••••••••••',
                        fillColor: const Color(0xffDFF7E2),
                        borderRadius: 18.r,
                        textStyle: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff093030),
                        ),
                        isPasswordField: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Hãy nhập mật khẩu của bạn';
                          }
                          if (value.length < 6) {
                            return 'Mật khẩu phải có ít nhất 6 ký tự';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Confirm Password',
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff093030),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      ButtonTextFilledWidget(
                        controller: confirmPasswordController,
                        hintText: '••••••••••••',
                        fillColor: const Color(0xffDFF7E2),
                        borderRadius: 18.r,
                        textStyle: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff093030),
                        ),
                        isPasswordField: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Hãy xác nhận mật khẩu của bạn';
                          }
                          if (value != passwordController.text) {
                            return 'Hãy xác nhận mật khẩu khớp với mật khẩu đã nhập';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      Consumer<SignUpProvider>(
                        builder: (context, signUpProvider, _) {
                          return Center(
                            child: signUpProvider.isLoading
                                ? const CircularProgressIndicator()
                                : ButtonTextWidget(
                                    text: 'Sign Up',
                                    color: const Color(0xff00D09E),
                                    width: 207.w,
                                    height: 45.h,
                                    radius: 30.r,
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        signUpProvider
                                            .signUpWithEmailAndPassword(
                                              emailController.text.trim(),
                                              passwordController.text.trim(),
                                            )
                                            .then((_) {
                                              if (signUpProvider.errorMessage ==
                                                  null) {
                                                ShowMessage(
                                                  context: context,
                                                  title: "Sign Up Successful",
                                                  description:
                                                      "Your account has been created.",
                                                  type: ToastificationType
                                                      .success,
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  duration: const Duration(
                                                    seconds: 3,
                                                  ),
                                                );
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  RouterName.signin,
                                                );
                                              } else {
                                                ShowMessage(
                                                  context: context,
                                                  title: "Sign Up Failed",
                                                  description: signUpProvider
                                                      .errorMessage!,
                                                  type:
                                                      ToastificationType.error,
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  duration: const Duration(
                                                    seconds: 3,
                                                  ),
                                                );
                                              }
                                            });
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff093030),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, RouterName.signin);
                            },
                            child: Text(
                              'Sign In',
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
