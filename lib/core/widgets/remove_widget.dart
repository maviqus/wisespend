import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/data/providers/category_provider.dart';
import 'package:wise_spend_app/data/providers/remove_provider.dart';

class RemoveWidget extends StatelessWidget {
  final String categoryId;

  const RemoveWidget({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final removeProvider = Provider.of<RemoveProvider>(context);

    return Center(
      child: Container(
        width: 500.w,
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Delete Category',
              style: GoogleFonts.poppins(
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff052224),
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              'Are you sure you want to delete this category?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                color: const Color(0xff052224),
              ),
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: removeProvider.isLoading
                  ? null
                  : () async {
                      Navigator.pop(context);
                      await Provider.of<CategoryProvider>(
                        context,
                        listen: false,
                      ).removeCategory(context, categoryId);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffDA736D),
                minimumSize: Size(double.infinity, 64.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.r),
                ),
                elevation: 0,
              ),
              child: removeProvider.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Delete',
                      style: GoogleFonts.poppins(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xffE6F9EC),
                minimumSize: Size(double.infinity, 64.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.r),
                ),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff052224),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
