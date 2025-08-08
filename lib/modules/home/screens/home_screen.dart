import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/core/widgets/icon_category_widget.dart';
import 'package:wise_spend_app/core/widgets/root_navbar.widget.dart';
import 'package:wise_spend_app/core/widgets/total_widget.dart';
import 'package:wise_spend_app/data/providers/total_provider.dart';
import 'package:wise_spend_app/routers/router_name.dart';
import 'package:wise_spend_app/core/widgets/category_block_widget.dart';
import 'package:wise_spend_app/modules/home/providers/home_provider.dart';
import 'package:wise_spend_app/modules/profile/providers/profile_provider.dart';
import 'package:wise_spend_app/core/widgets/profile_avatar_widget.dart'; // Import the shared widget

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<TotalProvider>(context, listen: false).listenTotalAll();
      }
    });
  }

  Future<void> _showAddCategoryDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 50.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
              ),
              padding: EdgeInsets.all(32.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Thêm Danh Mục',
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2E4E3E),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Form(
                    key: formKey,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F7EE),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: TextFormField(
                        controller: nameController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Hãy nhập danh mục mới...',
                          hintStyle: GoogleFonts.poppins(
                            color: const Color(0xFF00D09E),
                            fontSize: 16.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 16.h,
                          ),
                        ),
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          color: Colors.black,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tên danh mục';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Consumer<HomeProvider>(
                    builder: (context, homeProvider, _) {
                      return Column(
                        children: [
                          // Save button
                          SizedBox(
                            width: double.infinity,
                            height: 56.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff00D09E),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  final result = await homeProvider.addCategory(
                                    context,
                                    nameController.text,
                                  );
                                  if (!mounted) return;
                                  Navigator.pop(context);

                                  // Navigate to customization if category was created successfully
                                  if (result != null) {
                                    Navigator.pushNamed(
                                      context,
                                      RouterName.categoryCustomization,
                                      arguments: {
                                        'categoryId': result['id'],
                                        'categoryName': result['name'],
                                      },
                                    );
                                  }
                                }
                              },
                              child: Text(
                                'Lưu',
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
                                'Huỷ',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF2E4E3E),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCategoryOptionsDialog(
    BuildContext context,
    String categoryId,
    String categoryName,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
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
                      _showDeleteCategoryDialog(
                        context,
                        categoryId,
                        categoryName,
                      );
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
      },
    );
  }

  void _showDeleteCategoryDialog(
    BuildContext context,
    String categoryId,
    String categoryName,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
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
                // Warning icon
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_rounded,
                    color: Colors.red,
                    size: 40.sp,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Xoá Danh Mục',
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E4E3E),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Bạn có chắc chắn muốn xoá danh mục "$categoryName"?',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),
                Consumer<HomeProvider>(
                  builder: (context, homeProvider, _) {
                    return Column(
                      children: [
                        // Delete button
                        SizedBox(
                          width: double.infinity,
                          height: 56.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              homeProvider.deleteCategory(
                                context,
                                categoryId,
                                categoryName,
                              );
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Xoá',
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
                              'Huỷ',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF2E4E3E),
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFinanceCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required double amount,
    required Color backgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: iconColor, size: 24.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            NumberFormat.currency(
              locale: 'vi_VN',
              symbol: '₫',
              decimalDigits: 0,
            ).format(amount),
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(HomeProvider homeProvider) {
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
              onPressed: () => _showAddCategoryDialog(context),
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
        crossAxisCount: 3,
        childAspectRatio: 0.9,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 20.h,
      ),
      itemCount: homeProvider.categories.length + 1,
      itemBuilder: (context, index) {
        if (index == homeProvider.categories.length) {
          return GestureDetector(
            onTap: () => _showAddCategoryDialog(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: const Color(0xff00D09E).withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: const Color(0xff00D09E),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    color: const Color(0xff00D09E),
                    size: 40.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Thêm mới',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
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
          onLongPress: () =>
              _showCategoryOptionsDialog(context, categoryId, categoryName),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, _) {
        return Scaffold(
          backgroundColor: const Color(0xff00D09E),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xin chào, Chào mừng trở lại',
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  homeProvider.greeting,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            titleSpacing: 24.w,
            actions: [
              GestureDetector(
                onTap: () {
                  // Navigate to profile screen
                  Navigator.pushNamed(context, RouterName.profile);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 24.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Consumer<ProfileProvider>(
                    builder: (context, profileProvider, _) {
                      return ProfileAvatar(
                        // Force refresh on home screen using provider flag
                        key: ValueKey(
                          'home-${profileProvider.forceAvatarRefresh ? 'refresh' : 'normal'}-${DateTime.now().millisecondsSinceEpoch}',
                        ),
                        profileUrl: profileProvider.profilePicUrl,
                        userName: profileProvider.userName,
                        radius: 20.r,
                        forceRefresh: profileProvider.forceAvatarRefresh,
                      );
                    },
                  ),
                ),
              ),
            ],
            toolbarHeight: 100.h,
          ),
          body: Consumer<TotalProvider>(
            builder: (context, totalProvider, child) {
              final totalExpense = totalProvider.totalExpense.abs();
              final totalIncome = totalProvider.totalIncome;

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        const TotalWidget(),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildFinanceCard(
                            icon: Icons.arrow_upward_rounded,
                            iconColor: Colors.green,
                            title: 'Thu nhập',
                            amount: totalIncome,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _buildFinanceCard(
                            icon: Icons.arrow_downward_rounded,
                            iconColor: Colors.blue,
                            title: 'Chi tiêu',
                            amount: totalExpense,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1FFF3),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.r),
                          topRight: Radius.circular(40.r),
                        ),
                      ),
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Danh mục',
                                style: GoogleFonts.poppins(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  _showAddCategoryDialog(context);
                                },
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  size: 20.sp,
                                  color: Colors.blue,
                                ),
                                label: Text(
                                  'Thêm mới',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff00D09E),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Expanded(
                            child: SingleChildScrollView(
                              child: _buildCategoryGrid(homeProvider),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          bottomNavigationBar: RootNavBar(currentIndex: 0),
        );
      },
    );
  }
}
