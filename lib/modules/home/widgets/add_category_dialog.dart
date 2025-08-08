import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/modules/home/providers/home_provider.dart';
import 'package:wise_spend_app/modules/category/screens/category_customization_screen.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController _categoryController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  void _showCustomizationOption(
    BuildContext context,
    String categoryId,
    String categoryName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Danh mục đã được tạo!'),
        content: Text(
          'Bạn có muốn tùy chỉnh giao diện cho "$categoryName" ngay bây giờ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Để sau'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryCustomizationScreen(
                    categoryId: categoryId,
                    categoryName: categoryName,
                  ),
                ),
              );

              // If changes were made, refresh the UI
              if (result == true && context.mounted) {
                final homeProvider = Provider.of<HomeProvider>(
                  context,
                  listen: false,
                );
                await homeProvider.loadCategories();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff00D09E),
            ),
            child: Text(
              'Tùy chỉnh ngay',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Thêm Danh Mục',
              style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff0E3E3E),
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xffE6F9EC),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: TextField(
                controller: _categoryController,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  color: const Color(0xff0E3E3E),
                ),
                decoration: InputDecoration(
                  hintText: 'Thêm danh mục của bạn...',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: const Color(0xff7ED9B6),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 15.h,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Consumer<HomeProvider>(
              builder: (context, provider, _) {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              if (_categoryController.text.trim().isNotEmpty) {
                                final result = await provider.addCategory(
                                  context,
                                  _categoryController.text.trim(),
                                );
                                if (context.mounted && result != null) {
                                  // Show customization dialog after successful creation
                                  Navigator.pop(context);
                                  _showCustomizationOption(
                                    context,
                                    result['id'],
                                    result['name'],
                                  );
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00D09E),
                        minimumSize: Size(double.infinity, 56.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                        elevation: 0,
                      ),
                      child: provider.isLoading
                          ? SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Thêm',
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xffE6F9EC),
                minimumSize: Size(double.infinity, 56.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.r),
                ),
              ),
              child: Text(
                'Huỷ',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff0E3E3E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
