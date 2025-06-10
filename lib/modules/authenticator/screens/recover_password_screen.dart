import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/core/widgets/button_text_filled_widget.dart';
import 'package:wise_spend_app/core/widgets/button_text_widget.dart';
import 'package:wise_spend_app/modules/authenticator/providers/forgot_password_provider.dart';
import 'package:wise_spend_app/routers/router_name.dart';

class RecoverPasswordScreen extends StatefulWidget {
  const RecoverPasswordScreen({super.key});

  @override
  State<RecoverPasswordScreen> createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Password')),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'New Password',
                style: GoogleFonts.poppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 30.h),
              ButtonTextFilledWidget(
                controller: _newPasswordController,
                hintText: 'New Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter new password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              ButtonTextFilledWidget(
                controller: _confirmPasswordController,
                hintText: 'Confirm New Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              Consumer<ForgotPasswordProvider>(
                builder: (context, forgotPasswordProvider, _) {
                  return ButtonTextWidget(
                    text: 'Change Password',
                    color: const Color(0xff00D09E),
                    radius: 30.r,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        _newPasswordController.text.trim();

                        Navigator.pushReplacementNamed(
                          context,
                          RouterName.signin,
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
