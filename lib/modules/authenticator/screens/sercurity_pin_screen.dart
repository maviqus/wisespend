import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wise_spend_app/core/widgets/button_text_widget.dart';
import 'package:wise_spend_app/routers/router_name.dart';

class SecurityPinScreen extends StatefulWidget {
  const SecurityPinScreen({super.key});

  @override
  State<SecurityPinScreen> createState() => _SecurityPinScreenState();
}

class _SecurityPinScreenState extends State<SecurityPinScreen> {
  String _pin = '';
  final int _pinLength = 4;

  void _addDigit(String digit) {
    if (_pin.length < _pinLength) {
      setState(() {
        _pin += digit;
      });
    }

    if (_pin.length == _pinLength) {
      _verifyPin();
    }
  }

  void _removeDigit() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _verifyPin() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushNamed(context, RouterName.recoverPassword);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1FFF3),
      appBar: AppBar(
        backgroundColor: const Color(0xff00D09E),
        title: Text(
          'Xác thực bảo mật',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nhập mã PIN của bạn',
              style: GoogleFonts.poppins(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            Text(
              'Vui lòng nhập mã PIN để tiếp tục khôi phục mật khẩu',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pinLength, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < _pin.length
                        ? const Color(0xff00D09E)
                        : Colors.grey.shade300,
                  ),
                );
              }),
            ),

            SizedBox(height: 40.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16.h,
                  crossAxisSpacing: 16.w,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  if (index == 9) {
                    return const SizedBox.shrink();
                  } else if (index == 10) {
                    return _buildKeypadButton('0');
                  } else if (index == 11) {
                    return InkWell(
                      onTap: _removeDigit,
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                        ),
                        child: Icon(
                          Icons.backspace_outlined,
                          color: Colors.black,
                          size: 28.sp,
                        ),
                      ),
                    );
                  }

                  return _buildKeypadButton('${index + 1}');
                },
              ),
            ),

            SizedBox(height: 40.h),

            ButtonTextWidget(
              text: 'Xác nhận',
              color: const Color(0xff00D09E),
              radius: 24,
              onTap: () {
                if (_pin.length == _pinLength) {
                  _verifyPin();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadButton(String digit) {
    return InkWell(
      onTap: () => _addDigit(digit),
      borderRadius: BorderRadius.circular(40),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade200,
        ),
        alignment: Alignment.center,
        child: Text(
          digit,
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
