import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/core/widgets/icon_category_widget.dart';
import 'package:wise_spend_app/data/providers/remove_provider.dart';
import 'package:intl/intl.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.expense,
    required this.expenseId,
  });

  final Map<String, dynamic> expense;
  final String expenseId;

  @override
  Widget build(BuildContext context) {
    final categoryId = expense['categoryId'];
    if (categoryId == null || categoryId is! String) {
      return const SizedBox.shrink();
    }
    final type = expense['type'] ?? 'Chi';
    final amount = (expense['amount'] ?? 0).toDouble();
    final isIncome = type == 'Thu';
    final amountText = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
    ).format(amount.abs());
    final sign = isIncome ? '+' : '-';
    final amountColor = isIncome ? Colors.green : Colors.red;
    return Dismissible(
      key: Key(expenseId),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        Provider.of<RemoveProvider>(
          context,
          listen: false,
        ).removeExpense(context, expenseId, categoryId);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
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
                child: IconCategoryWidget(name: expense['category']),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense['title'],
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff093030),
                    ),
                  ),
                  Text(
                    expense['message'],
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: const Color(0xff093030),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Text(
              '$sign$amountText',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: amountColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
