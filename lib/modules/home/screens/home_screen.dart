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
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Thêm danh mục mới',
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Tên danh mục',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFE6F7EE),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên danh mục';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Hủy',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
            Consumer<HomeProvider>(
              builder: (context, homeProvider, _) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00D09E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      homeProvider.addCategory(context, nameController.text);
                      if (!mounted) return; // Add mounted check here
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Thêm',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
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
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Xóa danh mục',
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Bạn có chắc chắn muốn xóa danh mục "$categoryName"?\nTất cả khoản chi trong danh mục này cũng sẽ bị xóa.',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Hủy',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
            Consumer<HomeProvider>(
              builder: (context, homeProvider, _) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
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
                    'Xóa',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
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

        final categoryIcon = IconCategoryWidget.getCategoryIcon(categoryName);
        final categoryColor = IconCategoryWidget.getCategoryColor(categoryName);

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
              _showDeleteCategoryDialog(context, categoryId, categoryName),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: Consumer<HomeProvider>(
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, RouterName.addExpenses);
              },
              backgroundColor: const Color(0xff00D09E),
              child: const Icon(Icons.add, color: Colors.white),
            ),
            bottomNavigationBar: RootNavBar(currentIndex: 0),
          );
        },
      ),
    );
  }
}
