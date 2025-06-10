import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wise_spend_app/core/widgets/root_navbar.widget.dart';
import 'package:wise_spend_app/core/widgets/button_text_filled_widget.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/data/providers/save_data_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  DateTime selectedDate = DateTime.now();
  String? selectedCategory;
  final amountController = TextEditingController();
  final titleController = TextEditingController();
  final messageController = TextEditingController();

  final categories = [
    'Food',
    'Transport',
    'Medicine',
    'Groceries',
    'Rent',
    'Gifts',
    'Savings',
    'Entertainment',
    'More',
  ];

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _saveExpense() async {
    if (selectedCategory == null ||
        amountController.text.isEmpty ||
        titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final expense = {
      'category': selectedCategory,
      'amount': double.parse(amountController.text),
      'title': titleController.text,
      'message': messageController.text,
      'date': selectedDate.toIso8601String(),
    };

    try {
      await context.read<SaveDataProvider>().saveExpense(expense);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00D09E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: const Color(0xff093030)),
        title: Text(
          'Add Expenses',
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
            child: Image.asset(
              'assets/images/ic_bell.png',
              width: 32.sp,
              height: 32.sp,
              color: const Color(0xff093030),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xffF1FFF3),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.r),
            topRight: Radius.circular(50.r),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date
              Text(
                'Date',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff093030),
                ),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: _pickDate,
                child: ButtonTextFilledWidget(
                  controller: TextEditingController(
                    text:
                        "${selectedDate.month}/${selectedDate.day}, ${selectedDate.year}",
                  ),
                  hintText: 'Select date',
                  fillColor: const Color(0xffE9FFF3),
                  borderRadius: 24,
                  textStyle: GoogleFonts.poppins(
                    color: const Color(0xff093030),
                    fontSize: 16.sp,
                  ),
                  height: 56,
                  enabled: false,
                  suffixIcon: const Icon(
                    Icons.calendar_month,
                    color: Color(0xff00D09E),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Category
              Text(
                'Category',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff093030),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                height: 56.h,
                decoration: BoxDecoration(
                  color: const Color(0xffE9FFF3),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  hint: Text(
                    'Select the category',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 16.sp,
                    ),
                  ),
                  decoration: const InputDecoration(border: InputBorder.none),
                  items: categories
                      .map(
                        (cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(
                            cat,
                            style: GoogleFonts.poppins(
                              color: const Color(0xff093030),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xff00D09E),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Amount
              Text(
                'Amount',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff093030),
                ),
              ),
              SizedBox(height: 8.h),
              ButtonTextFilledWidget(
                controller: amountController,
                hintText: '0',
                fillColor: const Color(0xffE9FFF3),
                borderRadius: 24,
                textStyle: GoogleFonts.poppins(
                  color: const Color(0xff093030),
                  fontSize: 16.sp,
                ),
                height: 56,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 8.w, right: 4.w),
                  child: Text(
                    '₫',
                    style: GoogleFonts.poppins(
                      color: const Color(0xff093030),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20.h),

              Text(
                'Expense Title',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff093030),
                ),
              ),
              SizedBox(height: 8.h),
              ButtonTextFilledWidget(
                controller: titleController,
                hintText: 'Enter title',
                fillColor: const Color(0xffE9FFF3),
                borderRadius: 24,
                textStyle: GoogleFonts.poppins(
                  color: const Color(0xff093030),
                  fontSize: 16.sp,
                ),
                height: 56,
              ),
              SizedBox(height: 20.h),

              // Message
              ButtonTextFilledWidget(
                controller: messageController,
                hintText: 'Enter Message',
                fillColor: const Color(0xffE9FFF3),
                borderRadius: 24,
                textStyle: GoogleFonts.poppins(
                  color: const Color(0xff00D09E),
                  fontSize: 16.sp,
                ),
                height: 120,
              ),
              SizedBox(height: 32.h),

              // Save
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00D09E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 60.w,
                      vertical: 14.h,
                    ),
                  ),
                  onPressed: _saveExpense,
                  child: Text(
                    'Save',
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RootNavBar(currentIndex: 3),
    );
  }
}
