import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/data/providers/category_provider.dart';
import 'package:wise_spend_app/core/services/firebase_service.dart';
import 'package:wise_spend_app/core/widgets/notification_widget.dart';

class MoreWidget extends StatefulWidget {
  const MoreWidget({super.key});

  @override
  State<MoreWidget> createState() => _MoreWidgetState();
}

class _MoreWidgetState extends State<MoreWidget> {
  final TextEditingController _categoryController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _addCategory() async {
    final name = _categoryController.text.trim();
    if (name.isEmpty) {
      NotificationWidget.show(
        context,
        'Tên danh mục không được để trống',
        type: NotificationType.error,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Add your logic to add category here
      // Example: await Provider.of<CategoryProvider>(context, listen: false).addCategory({'name': name});
      NotificationWidget.show(
        context,
        'Thêm danh mục thành công',
        type: NotificationType.success,
      );
      _categoryController.clear();
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      NotificationWidget.show(
        context,
        'Lỗi: $e',
        type: NotificationType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              'Thêm danh mục mới',
              style: GoogleFonts.poppins(
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff093030),
              ),
            ),
            SizedBox(height: 32.h),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                hintText: 'Nhập tên danh mục...',
                filled: true,
                fillColor: const Color(0xffE6F9EC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.r),
                  borderSide: BorderSide.none,
                ),
                hintStyle: GoogleFonts.poppins(
                  color: const Color(0xff7ED9B6),
                  fontSize: 18.sp,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 16.h,
                ),
              ),
              style: GoogleFonts.poppins(
                color: const Color(0xff093030),
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: _isLoading ? null : _addCategory,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4AD7A7),
                minimumSize: Size(double.infinity, 64.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.r),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Lưu',
                      style: GoogleFonts.poppins(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff093030),
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
                'Hủy',
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff093030),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff093030),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
