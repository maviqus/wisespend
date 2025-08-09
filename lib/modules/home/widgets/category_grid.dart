import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wise_spend_app/core/widgets/icon_category_widget.dart';
import 'package:wise_spend_app/core/widgets/category_block_widget.dart';
import 'package:wise_spend_app/modules/home/providers/home_provider.dart';
import 'package:wise_spend_app/routers/router_name.dart';

class CategoryGrid extends StatelessWidget {
  final HomeProvider homeProvider;
  final VoidCallback onShowAddDialog;
  final Function(String categoryId, String categoryName) onShowOptionsDialog;

  const CategoryGrid({
    super.key,
    required this.homeProvider,
    required this.onShowAddDialog,
    required this.onShowOptionsDialog,
  });

  int _getCrossAxisCount() {
    return 3; // Giữ 3 cột cho tất cả thiết bị
  }

  double _getChildAspectRatio() {
    return 1.1; // Tăng ratio để có thêm không gian cho text
  }

  double _getAddButtonSize() {
    return 70.w; // Kích thước cố định
  }

  double _getAddIconSize() {
    return 32.sp; // Icon size cố định
  }

  double _getAddFontSize() {
    return 12.sp; // Font size cố định
  }

  @override
  Widget build(BuildContext context) {
    if (homeProvider.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: const Color(0xff00D09E)),
      );
    }

    if (homeProvider.categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'Chưa có danh mục nào',
              style: GoogleFonts.poppins(fontSize: 16.sp, color: Colors.grey),
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              onPressed: onShowAddDialog,
              icon: Icon(Icons.add_circle_outline, size: 20.sp),
              label: Text('Thêm danh mục'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff00D09E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            TextButton.icon(
              onPressed: () {
                homeProvider.restoreDefaultCategories(context);
              },
              icon: Icon(Icons.restore, size: 20.sp),
              label: Text(
                'Khôi phục danh mục mặc định',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff00D09E),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(),
        childAspectRatio: _getChildAspectRatio(),
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: homeProvider.categories.length + 1,
      itemBuilder: (context, index) {
        if (index == homeProvider.categories.length) {
          return GestureDetector(
            onTap: onShowAddDialog,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 3,
                  child: Container(
                    width: _getAddButtonSize(),
                    height: _getAddButtonSize(),
                    decoration: BoxDecoration(
                      color: const Color(0xff00D09E).withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: const Color(0xff00D09E),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      color: const Color(0xff00D09E),
                      size: _getAddIconSize(),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Flexible(
                  flex: 1,
                  child: Text(
                    'Thêm mới',
                    style: GoogleFonts.poppins(
                      fontSize: _getAddFontSize(),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }

        final category = homeProvider.categories[index];
        final categoryName = category['name'] as String? ?? '';
        final categoryId = category['id'] as String? ?? '';

        // Check for custom settings
        final customColorHex = category['customColor'] as String?;
        final customIconCode = category['customIconCode'] as int?;

        // Use custom settings if available, otherwise default
        final categoryIcon = customIconCode != null
            ? IconData(customIconCode, fontFamily: 'MaterialIcons')
            : IconCategoryWidget.getCategoryIcon(categoryName);

        final categoryColor = customColorHex != null
            ? Color(int.parse('0x$customColorHex'))
            : IconCategoryWidget.getCategoryColor(categoryName);

        return CategoryBlockWidget(
          name: categoryName,
          icon: categoryIcon,
          color: categoryColor,
          onTap: () {
            Navigator.pushNamed(
              context,
              RouterName.categories,
              arguments: {'label': categoryName, 'categoryId': categoryId},
            );
          },
          onLongPress: () => onShowOptionsDialog(categoryId, categoryName),
        );
      },
    );
  }
}
