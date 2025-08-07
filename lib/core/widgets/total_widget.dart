import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/data/providers/total_provider.dart';

class TotalWidget extends StatelessWidget {
  const TotalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TotalProvider>(
      builder: (context, provider, child) {
        final totalBalance = provider.totalBalance;
        final totalExpense = provider.totalExpense;

        double percentDisplay = 0;
        if (totalBalance == 0 && totalExpense != 0) {
          percentDisplay = 100;
        } else if (totalBalance > 0) {
          percentDisplay =
              (totalExpense.abs() / (totalBalance + totalExpense.abs())) * 100;
        } else if (totalBalance < 0) {
          percentDisplay = (totalExpense.abs() / totalExpense.abs()) * 100;
        }
        if (percentDisplay < 0) percentDisplay = 0;

        Color percentColor;
        if (percentDisplay < 40) {
          percentColor = const Color(0xff3299FF);
        } else if (percentDisplay >= 40 && percentDisplay <= 70) {
          percentColor = Colors.orange;
        } else {
          percentColor = Colors.red;
        }

        final balanceColor = totalBalance < 0 ? Colors.red : Colors.white;

        return AnimatedOpacity(
          opacity: provider.isTransitioning ? 0.3 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tổng số dư',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          NumberFormat.currency(
                            locale: 'vi_VN',
                            symbol: '₫',
                          ).format(totalBalance),
                          style: GoogleFonts.poppins(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: balanceColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40.h,
                    color: Colors.white.withAlpha(77),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Tổng chi tiêu tháng',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: const Color(0xff093030),
                          ),
                        ),
                        Text(
                          NumberFormat.currency(
                            locale: 'vi_VN',
                            symbol: '₫',
                          ).format(totalExpense.abs()),
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
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: percentColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '${percentDisplay.toStringAsFixed(0)}%',
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
                            widthFactor: (percentDisplay / 100).clamp(0.0, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: percentColor,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 12.w),
                              child: Text(
                                NumberFormat.currency(
                                  locale: 'vi_VN',
                                  symbol: '₫',
                                ).format(totalBalance),
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  color: balanceColor,
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
            ],
          ),
        );
      },
    );
  }
}
