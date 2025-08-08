import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/core/services/firebase_service.dart';
import 'package:wise_spend_app/core/widgets/date_picker/date_picker_widget.dart';
import 'package:wise_spend_app/data/providers/category_provider.dart';
import 'package:wise_spend_app/core/widgets/category_item_widget.dart';
import 'package:wise_spend_app/routers/router_name.dart';
import 'package:wise_spend_app/core/widgets/animated_loader.dart';
import 'package:wise_spend_app/modules/profile/providers/profile_provider.dart';
import 'package:wise_spend_app/core/widgets/profile_avatar_widget.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    super.key,
    required this.label,
    required this.categoryId,
  });

  final String label;
  final String categoryId;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00D09E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: const Color(0xff093030)),
        title: Text(
          widget.label,
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff093030),
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
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
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Consumer<ProfileProvider>(
                  builder: (context, profileProvider, _) {
                    return ProfileAvatar(
                      profileUrl: profileProvider.profilePicUrl,
                      userName: profileProvider.userName,
                      radius: 16.r,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffF1FFF3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.r),
                  topRight: Radius.circular(40.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date
                    Consumer<CategoryProvider>(
                      builder: (context, categoryProvider, _) {
                        return DatePickerWidget(
                          initialDates: categoryProvider.selectedDate,
                          callBackFuntion: (dates) {
                            if (dates.isEmpty) {
                              categoryProvider.selectedDate = [];
                              return;
                            }
                            final List<DateTime?> selected =
                                List<DateTime?>.from(
                                  categoryProvider.selectedDate,
                                );
                            if (dates.isNotEmpty && dates[0] != null) {
                              DateTime tapped = dates[0]!;
                              final exists = selected.any(
                                (d) =>
                                    d != null &&
                                    d.year == tapped.year &&
                                    d.month == tapped.month &&
                                    d.day == tapped.day,
                              );
                              if (exists && selected.length == 1) {
                                categoryProvider.selectedDate = [];
                              } else if (exists) {
                                selected.removeWhere(
                                  (d) =>
                                      d != null &&
                                      d.year == tapped.year &&
                                      d.month == tapped.month &&
                                      d.day == tapped.day,
                                );
                                categoryProvider.selectedDate = selected;
                              } else {
                                selected.add(tapped);
                                categoryProvider.selectedDate = selected;
                              }
                            }
                          },
                        );
                      },
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Lịch sử chi tiêu',
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff093030),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: Consumer<CategoryProvider>(
                        builder: (context, categoryProvider, child) {
                          final selectedDate = categoryProvider.selectedDate;
                          debugPrint('🗓️ Selected dates: $selectedDate');
                          return StreamBuilder(
                            stream: FirebaseService.getExpensesOfCategory(
                              widget.categoryId,
                              date: selectedDate.isEmpty ? null : selectedDate,
                            ),
                            builder: (context, snapshot) {
                              final bool isLoading =
                                  snapshot.connectionState ==
                                  ConnectionState.waiting;

                              if (snapshot.hasError) {
                                debugPrint(
                                  '❌ Category screen error: ${snapshot.error}',
                                );
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 48,
                                        color: Colors.red,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Lỗi khi tải dữ liệu',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '${snapshot.error}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                          categoryProvider.selectedDate = [];
                                        },
                                        child: Text('Thử lại'),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              final expenses = snapshot.data?.docs ?? [];
                              debugPrint(
                                '📊 Found ${expenses.length} expenses for category ${widget.categoryId}',
                              );

                              return AnimatedLoader(
                                isLoading: isLoading,
                                child: expenses.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'Không có khoản chi nào cho danh mục này.',
                                        ),
                                      )
                                    : FadeInWidget(
                                        child: ListView.builder(
                                          itemCount: expenses.length,
                                          itemBuilder: (context, index) {
                                            final expense = expenses[index]
                                                .data();
                                            final expenseId =
                                                expenses[index].id;
                                            return CategoryItem(
                                              expense: expense,
                                              expenseId: expenseId,
                                            );
                                          },
                                        ),
                                      ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff00D09E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.w,
                            vertical: 12.h,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            RouterName.addExpenses,
                            arguments: widget.categoryId,
                          );
                        },
                        child: Text(
                          'Thêm khoản chi',
                          style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            RouterName.addExpenses,
            arguments: widget.categoryId,
          );
        },
        backgroundColor: const Color(0xff00D09E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
