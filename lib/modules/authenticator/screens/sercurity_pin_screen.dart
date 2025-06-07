import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/core/widgets/button_text_widget.dart';
import 'package:wise_spend_app/modules/authenticator/providers/forgot_password_provider.dart';
import 'package:wise_spend_app/routers/router_name.dart';

class SercurityPinScreen extends StatefulWidget {
  const SercurityPinScreen({super.key});

  @override
  State<SercurityPinScreen> createState() => _SercurityPinScreenState();
}

class _SercurityPinScreenState extends State<SercurityPinScreen> {
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security Pin')),
      body: Consumer<ForgotPasswordProvider>(
        builder: (context, forgotPasswordProvider, _) {
          return Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                Text(
                  'Enter Security Pin',
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 30.h),
                TextFormField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: 'Enter 6-digit PIN',
                  ),
                ),
                SizedBox(height: 20.h),
                ButtonTextWidget(
                  text: 'Accept',
                  color: const Color(0xff00D09E),
                  radius: 30.r,
                  onTap: () {
                    Navigator.pushNamed(context, RouterName.recoverPassword);
                  },
                ),
                SizedBox(height: 10.h),
                TextButton(onPressed: () {}, child: const Text('Send Again')),
              ],
            ),
          );
        },
      ),
    );
  }
}
