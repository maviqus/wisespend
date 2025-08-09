import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wise_spend_app/routers/router_name.dart';

class CategoryOptionsDialog extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final VoidCallback onDelete;

  const CategoryOptionsDialog({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              categoryName,
              style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2E4E3E),
              ),
            ),
            SizedBox(height: 24.h),

            // Edit button
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff00D09E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    RouterName.categoryCustomization,
                    arguments: {
                      'categoryId': categoryId,
                      'categoryName': categoryName,
                    },
                  );
                },
                icon: Icon(Icons.edit, color: Colors.white, size: 20.sp),
                label: Text(
                  'Chỉnh sửa',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Delete button
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  onDelete();
                },
                icon: Icon(Icons.delete, color: Colors.white, size: 20.sp),
                label: Text(
                  'Xóa',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Cancel button
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6F7EE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Hủy',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF2E4E3E),
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> show(
    BuildContext context, {
    required String categoryId,
    required String categoryName,
    required VoidCallback onDelete,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CategoryOptionsDialog(
        categoryId: categoryId,
        categoryName: categoryName,
        onDelete: onDelete,
      ),
    );
  }
}
