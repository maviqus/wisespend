import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/core/widgets/button_text_filled_widget.dart';
import 'package:wise_spend_app/core/widgets/button_text_widget.dart';
import 'package:wise_spend_app/modules/authenticator/providers/forgot_password_provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
  // Ensure forgot password provider is initialized
  Provider.of<ForgotPasswordProvider>(context, listen: false);

    return _ForgotPasswordContent();
  }
}

class _ForgotPasswordContent extends StatefulWidget {
  const _ForgotPasswordContent();

  @override
  State<_ForgotPasswordContent> createState() => _ForgotPasswordContentState();
}

class _ForgotPasswordContentState extends State<_ForgotPasswordContent> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00D09E),
      body: Column(
        children: [
          SizedBox(height: 100.h),
          Text(
            'Quên mật khẩu',
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
                        'Nhập email đã đăng ký để nhận hướng dẫn đặt lại mật khẩu',
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff093030),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.h),
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
                            return 'Vui lòng nhập email';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Email không hợp lệ';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 40.h),
                      Consumer<ForgotPasswordProvider>(
                        builder: (context, fpProvider, _) {
                          return Center(
                            child: (fpProvider.isLoading)
                                ? const CircularProgressIndicator()
                                : ButtonTextWidget(
                                    text: 'Gửi email',
                                    color: const Color(0xff00D09E),
                                    width: 207.w,
                                    height: 45.h,
                                    radius: 30.r,
                                    onTap: () async {
                                      if (_formKey.currentState!.validate()) {
                                        final email = _emailController.text
                                            .trim();
                                        await fpProvider.sendPasswordResetEmail(email);
                                        if (!context.mounted) return;
                                        final err = fpProvider.errorMessage;
                                        if (err == null) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Email đặt lại mật khẩu đã được gửi. Vui lòng kiểm tra hộp thư.'),
                                            ),
                                          );
                                          Navigator.pop(context); // quay lại màn login
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Lỗi: $err')),
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
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Quay lại đăng nhập',
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff093030),
                            ),
                          ),
                        ),
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
