import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavIcon extends StatelessWidget {
  final String asset;
  final bool isActive;
  final VoidCallback onTap;

  const BottomNavIcon({
    super.key,
    required this.asset,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: isActive
            ? BoxDecoration(
                color: const Color(0xff00D09E),
                borderRadius: BorderRadius.circular(16.r),
              )
            : null,
        padding: EdgeInsets.all(6.w),
        child: Image.asset(
          asset,
          width: 32.sp,
          height: 32.sp,
          color: isActive ? Colors.white : const Color(0xff093030),
        ),
      ),
    );
  }
}
