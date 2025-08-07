import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryDropdownWidget extends StatelessWidget {
  const CategoryDropdownWidget({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
  });

  final List<Map<String, dynamic>> categories;
  final String? selectedCategory;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Select Category',
          hintStyle: GoogleFonts.poppins(
            fontSize: 16.sp,
            color: const Color(0xff093030),
          ),
        ),
        value: selectedCategory,
        items: categories.map((category) {
          return DropdownMenuItem<String>(
            value: category['id'],
            child: Text(
              category['name'],
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                color: const Color(0xff093030),
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
