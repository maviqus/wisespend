import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ButtonTextWidget extends StatelessWidget {
  final String text;
  final Color color;
  final double radius;
  final VoidCallback onTap;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final bool isLoading;

  const ButtonTextWidget({
    super.key,
    required this.text,
    required this.color,
    required this.radius,
    required this.onTap,
    this.textStyle,
    this.width,
    this.height,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isLoading) return;
        onTap();
      },
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 60.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              LoadingAnimationWidget.discreteCircle(
                color: Colors.white,
                size: 15,
              ),
              SizedBox(width: 10.w),
            ],
            Text(
              text,
              style:
                  textStyle ??
                  GoogleFonts.urbanist(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
