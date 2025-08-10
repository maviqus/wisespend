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
    // Use the existing provider from the parent
    return const _SignInScreenContent();
  }
}

class _SignInScreenContent extends StatefulWidget {
  const _SignInScreenContent();

  @override
  State<_SignInScreenContent> createState() => _SignInScreenContentState();
}

class _SignInScreenContentState extends State<_SignInScreenContent> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Reset controllers when screen initializes to ensure fresh login
    usernameController.clear();
    passwordController.clear();

    // Reset the provider state when the sign in screen is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final signInProvider = Provider.of<SignInProvider>(
          context,
          listen: false,
        );
        signInProvider.resetState();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00D09E),
      body: Column(
        children: [
          SizedBox(height: 100.h),
          Text(
            'Chào mừng',
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
                        'Email của bạn',
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
                        'Mật khẩu',
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
                                    text: 'Đăng nhập',
                                    color: const Color(0xff00D09E),
                                    width: 207.w,
                                    height: 45.h,
                                    radius: 30.r,
                                    onTap: () async {
                                      if (_formKey.currentState!.validate()) {
                                        try {
                                          await signInProvider
                                              .signInWithEmailAndPassword(
                                                usernameController.text.trim(),
                                                passwordController.text.trim(),
                                              );

                                          if (!mounted) return;

                                          // Check if there's an error message
                                          if (signInProvider.errorMessage != null) {
                                            String msg = signInProvider.errorMessage!;
                                            // Basic FirebaseAuth error localization
                                            if (msg.contains('wrong-password')) {
                                              msg = 'Sai mật khẩu';
                                            } else if (msg.contains('user-not-found')) {
                                              msg = 'Email không tồn tại';
                                            } else if (msg.contains('invalid-email')) {
                                              msg = 'Email không hợp lệ';
                                            } else if (msg.contains('too-many-requests')) {
                                              msg = 'Quá nhiều lần thử. Vui lòng thử lại sau';
                                            }
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(msg),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          } else if (signInProvider
                                              .isSignedIn) {
                                            print(
                                              "🔄 Navigating to home screen",
                                            );
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              RouterName.home,
                                              (route) => false,
                                            );
                                          }
                                        } catch (e) {
                                          print(
                                            "❌ Error in sign in button: ${e.toString()}",
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Error: ${e.toString()}",
                                              ),
                                              backgroundColor: Colors.red,
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
                      SizedBox(height: 10.h),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            // Navigate to forgot password screen without depending on ForgotPasswordProvider
                            Navigator.pushNamed(
                              context,
                              RouterName.forgotPassword,
                            );
                          },
                          child: Text(
                            'Quên mật khẩu?',
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
                          text: 'Đăng ký',
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
                            "Chưa có tài khoản?",
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
                              'Đăng ký',
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
