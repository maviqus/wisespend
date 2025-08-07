import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BudgetProgressBar extends StatelessWidget {
  final double totalExpense;
  final double maxBudget;
  final Color progressColor;
  final Color backgroundColor;

  const BudgetProgressBar({
    super.key,
    required this.totalExpense,
    required this.maxBudget,
    this.progressColor = const Color(0xff093030),
    this.backgroundColor = Colors.white,
  });

  double get percentage => maxBudget > 0
      ? (totalExpense.abs() / maxBudget * 100).clamp(0.0, 100.0)
      : 0.0;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Stack(
            children: [
              Container(
                height: 30.h,
                width: double.infinity,
                color: backgroundColor,
              ),
              FractionallySizedBox(
                widthFactor: percentage / 100,
                child: Container(
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: progressColor,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16.w),
                  child: Text(
                    '${percentage.toInt()}%',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 16.w,
                top: 6.h,
                child: Text(
                  currency.format(maxBudget),
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xff00D09E), size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              '${percentage.toInt()}% Chi tiêu của bạn, Tốt.',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xff093030),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FinanceSummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;

  const FinanceSummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1), // Changed from withOpacity
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: color, size: 22.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: GoogleFonts.poppins(fontSize: 16.sp, color: Colors.black54),
          ),
          Text(
            currency.format(amount),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 20.sp,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
