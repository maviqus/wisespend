import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wise_spend_app/core/widgets/root_navbar.widget.dart';
import 'package:wise_spend_app/modules/add_expenses/screens/add_expenses_screen.dart';
import 'package:wise_spend_app/routers/router_name.dart';

class CategoriesScreen extends StatelessWidget {
  final String? icon;
  final String? label;

  const CategoriesScreen({super.key, this.icon, this.label});

  @override
  Widget build(BuildContext context) {
    final expenses = [
      {
        'title': 'Dinner',
        'subtitle': '18:27 - April 30',
        'amount': '-\$26,00',
        'month': 'April',
      },
      {
        'title': 'Delivery Pizza',
        'subtitle': '15:00 - April 24',
        'amount': '-\$18,35',
        'month': 'April',
      },
      {
        'title': 'Lunch',
        'subtitle': '12:30 - April 15',
        'amount': '-\$15,40',
        'month': 'April',
      },
      {
        'title': 'Brunch',
        'subtitle': '9:30 - April 08',
        'amount': '-\$12,13',
        'month': 'April',
      },
      {
        'title': 'Dinner',
        'subtitle': '20:50 - March 31',
        'amount': '-\$27,20',
        'month': 'March',
      },
    ];

    // du lieu theo tháng
    final months = expenses.map((e) => e['month']).toSet().toList();

    return Scaffold(
      backgroundColor: const Color(0xff00D09E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: const Color(0xff093030)),
        title: Text(
          label ?? 'Category',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff093030),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RouterName.notification);
              },
              child: Image.asset(
                'assets/images/ic_bell.png',
                width: 32.sp,
                height: 32.sp,
                color: const Color(0xff093030),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xff00D09E),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Balance',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '\$7,783.00',
                            style: GoogleFonts.poppins(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40.h,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total Expense',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '-\$1.187.40',
                            style: GoogleFonts.poppins(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff3299FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // thanh progress
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff093030),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        '30%',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Stack(
                          children: [
                            FractionallySizedBox(
                              widthFactor: 0.3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff00D09E),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 12.w),
                                child: Text(
                                  '\$20,000.00',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    color: const Color(0xff00D09E),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    const Icon(
                      Icons.check_box,
                      color: Color(0xff093030),
                      size: 18,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '30% Of Your Expenses, Looks Good.',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: const Color(0xff093030),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Body
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xffF1FFF3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.r),
                  topRight: Radius.circular(50.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: ListView(
                  children: [
                    for (final month in months) ...[
                      Padding(
                        padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                        child: Text(
                          month!,
                          style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff093030),
                          ),
                        ),
                      ),
                      ...expenses
                          .where((e) => e['month'] == month)
                          .map(
                            (e) => Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: Row(
                                children: [
                                  Container(
                                    width: 56.w,
                                    height: 56.w,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff6DB6FE),
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    child: Center(
                                      child: icon != null
                                          ? Image.asset(
                                              icon!,
                                              width: 28.sp,
                                              height: 28.sp,
                                              color: const Color(0xffF1FFF3),
                                            )
                                          : const SizedBox(),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e['title'] as String,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xff093030),
                                          ),
                                        ),
                                        Text(
                                          e['subtitle'] as String,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13.sp,
                                            color: const Color(0xff3299FF),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    e['amount'] as String,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff3299FF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddExpenseScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Add Expenses',
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
      bottomNavigationBar: RootNavBar(currentIndex: 3),
    );
  }
}
