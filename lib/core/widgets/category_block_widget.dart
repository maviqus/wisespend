import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryBlockWidget extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final Function() onTap;
  final Function()? onLongPress;

  const CategoryBlockWidget({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.onTap,
    this.onLongPress,
  });

  double _getContainerSize() {
    return 70.w; // Kích thước cố định phù hợp cho tất cả thiết bị
  }

  double _getIconSize() {
    return 32.sp; // Icon size cố định
  }

  double _getFontSize() {
    return 12.sp; // Font size cố định
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 3,
              child: Container(
                width: _getContainerSize(),
                height: _getContainerSize(),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withValues(alpha: 0.3),
                      color.withValues(alpha: 0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.25),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    ),
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.5),
                      offset: const Offset(-1, -1),
                      blurRadius: 4,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: _getIconSize(),
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Flexible(
              flex: 1,
              child: Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: _getFontSize(),
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
