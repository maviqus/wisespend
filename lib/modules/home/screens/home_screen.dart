import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/core/widgets/root_navbar.widget.dart';
import 'package:wise_spend_app/core/widgets/total_widget.dart';
import 'package:wise_spend_app/data/providers/total_provider.dart';
import 'package:wise_spend_app/routers/router_name.dart';
import 'package:wise_spend_app/modules/home/providers/home_provider.dart';
import 'package:wise_spend_app/modules/profile/providers/profile_provider.dart';
import 'package:wise_spend_app/core/widgets/profile_avatar_widget.dart';
import 'package:wise_spend_app/modules/home/widgets/add_category_dialog.dart';
import 'package:wise_spend_app/modules/home/widgets/category_options_dialog.dart';
import 'package:wise_spend_app/modules/home/widgets/finance_card.dart';
import 'package:wise_spend_app/modules/home/widgets/category_grid.dart';

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
        Provider.of<ProfileProvider>(context, listen: false).loadUserData();
      }
    });
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AddCategoryDialog(),
    );
  }

  void _showCategoryOptionsDialog(String categoryId, String categoryName) {
    showDialog(
      context: context,
      builder: (context) => CategoryOptionsDialog(
        categoryId: categoryId,
        categoryName: categoryName,
        onDelete: () {
          final homeProvider = Provider.of<HomeProvider>(
            context,
            listen: false,
          );
          homeProvider.deleteCategory(context, categoryId, categoryName);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, _) {
        return Scaffold(
          backgroundColor: const Color(0xff00D09E),
          body: Column(
            children: [
              // Custom header thay cho AppBar
              Container(
                height: 100.h + MediaQuery.of(context).padding.top,
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  left: 16.w,
                  right: 24.w,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer<ProfileProvider>(
                            builder: (context, profileProvider, _) {
                              final userName =
                                  profileProvider.userName.isNotEmpty
                                  ? profileProvider.userName
                                  : 'Bạn';
                              return Text(
                                'Xin chào, $userName',
                                style: GoogleFonts.poppins(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              );
                            },
                          ),
                          Text(
                            homeProvider.getGreetingByTime(),
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RouterName.profile);
                      },
                      child: Container(
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
                ),
              ),
              // Body content
              Expanded(
                child: Consumer<TotalProvider>(
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
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                Expanded(
                                  child: FinanceCard(
                                    icon: Icons.arrow_upward_rounded,
                                    iconColor: Colors.green,
                                    title: 'Thu nhập',
                                    amount: totalIncome,
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: FinanceCard(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      onPressed: _showAddCategoryDialog,
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
                                    child: CategoryGrid(
                                      homeProvider: homeProvider,
                                      onShowAddDialog: _showAddCategoryDialog,
                                      onShowOptionsDialog:
                                          _showCategoryOptionsDialog,
                                    ),
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
              ),
            ],
          ),
          bottomNavigationBar: const RootNavBar(currentIndex: 0),
        );
      },
    );
  }
}
