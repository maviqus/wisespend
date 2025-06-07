import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wise_spend_app/core/utils/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, Welcome Back',
              style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
            Text(
              'Good Morning',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                color: AppTheme.lightTextColor,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Balance',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: AppTheme.lightTextColor,
                      ),
                    ),
                    Text(
                      '\$7,783.00',
                      style: GoogleFonts.poppins(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total Expense',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: AppTheme.lightTextColor,
                      ),
                    ),
                    Text(
                      '-\$1.187.40',
                      style: GoogleFonts.poppins(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Text(
                  '30%',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: AppTheme.textColor,
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: LinearProgressIndicator(
                    value: 0.3,
                    backgroundColor: AppTheme.lightTextColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                Text(
                  '\$20,000.00',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: AppTheme.lightTextColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              '30% Of Your Expenses, Looks Good.',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: AppTheme.lightTextColor,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.all(20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.savings,
                        size: 30.sp,
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Savings',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: AppTheme.textColor,
                        ),
                      ),
                      Text(
                        'On Goals',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: AppTheme.textColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.restaurant,
                        size: 30.sp,
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Revenue Last Week',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: AppTheme.textColor,
                        ),
                      ),
                      Text(
                        '\$4.000,00',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: AppTheme.textColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.food_bank,
                        size: 30.sp,
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Food Last Week',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: AppTheme.textColor,
                        ),
                      ),
                      Text(
                        '-\$100.00',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Daily',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: AppTheme.lightTextColor,
                  ),
                ),
                Text(
                  'Weekly',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: AppTheme.lightTextColor,
                  ),
                ),
                Text(
                  'Monthly',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.monetization_on,
                          size: 30.sp,
                          color: AppTheme.primaryColor,
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Salary',
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                color: AppTheme.textColor,
                              ),
                            ),
                            Text(
                              '18:27 - April 30',
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                color: AppTheme.lightTextColor,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          '\$4.000,00',
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            color: AppTheme.textColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transfer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Budget',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
