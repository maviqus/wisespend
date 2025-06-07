import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/core/widgets/button_text_filled_widget.dart';
import 'package:wise_spend_app/core/widgets/button_text_widget.dart';
import 'package:wise_spend_app/modules/authenticator/providers/sign_in_provier.dart';
import 'package:wise_spend_app/routers/router_name.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignInProvider(),
      child: const _SignInScreenContent(),
    );
  }
}

class _SignInScreenContent extends StatefulWidget {
  const _SignInScreenContent({super.key});

  @override
  State<_SignInScreenContent> createState() => _SignInScreenContentState();
}

class _SignInScreenContentState extends State<_SignInScreenContent> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00D09E),
      body: Column(
        children: [
          SizedBox(height: 100.h),
          Text(
            'Welcome',
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
              padding: EdgeInsets.symmetric(horizontal: 36.w),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 50.h),
                      Text(
                        'Username or Email',
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff093030),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      ButtonTextFilledWidget(
                        controller: usernameController,
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
                            return 'Vui lòng nhập email';
                          }
                          if (!value.contains('@')) {
                            return 'Email không hợp lệ';
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
                            return 'Vui lòng nhập mật khẩu';
                          }
                          if (value.length < 6) {
                            return 'Mật khẩu phải có ít nhất 6 ký tự';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 91.h),
                      Consumer<SignInProvider>(
                        builder: (context, signInProvider, _) {
                          return Center(
                            child: signInProvider.isLoading
                                ? const CircularProgressIndicator()
                                : ButtonTextWidget(
                                    text: 'Log In',
                                    color: const Color(0xff00D09E),
                                    width: 207.w,
                                    height: 45.h,
                                    radius: 30.r,
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        signInProvider
                                            .signInWithEmailAndPassword(
                                              usernameController.text.trim(),
                                              passwordController.text.trim(),
                                            )
                                            .then((_) {
                                              if (signInProvider.errorMessage ==
                                                  null) {
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  RouterName.home,
                                                );
                                              } else {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Đăng nhập thất bại: ${signInProvider.errorMessage}',
                                                    ),
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
                      SizedBox(height: 10.h),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouterName.forgotPassword,
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff093030),
                            ),
                          ),
                        ),
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
                          IconButton(
                            onPressed: () {
                              Provider.of<SignInProvider>(
                                context,
                                listen: false,
                              ).signInWithFacebook().then((_) {
                                if (Provider.of<SignInProvider>(
                                      context,
                                      listen: false,
                                    ).errorMessage ==
                                    null) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    RouterName.home,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Facebook sign-in failed: ${Provider.of<SignInProvider>(context, listen: false).errorMessage}',
                                      ),
                                    ),
                                  );
                                }
                              });
                            },
                            icon: const Icon(Icons.facebook),
                          ),
                          IconButton(
                            onPressed: () async {
                              try {
                                await Provider.of<SignInProvider>(
                                  context,
                                  listen: false,
                                ).signInWithGoogle();
                                if (!mounted) return;
                                final error = Provider.of<SignInProvider>(
                                  context,
                                  listen: false,
                                ).errorMessage;
                                if (error == null) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    RouterName.home,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Google sign-in failed: $error',
                                      ),
                                    ),
                                  );
                                }
                              } catch (e, stack) {
                                print('Exception in Google sign-in button: $e');
                                print('Stack: $stack');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('App crashed: $e')),
                                );
                              }
                            },
                            icon: const Icon(Icons.g_mobiledata),
                          ),
                        ],
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
