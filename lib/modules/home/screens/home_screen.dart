import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/core/widgets/root_navbar.widget.dart';
import 'package:wise_spend_app/data/providers/category_provider.dart';
import 'package:wise_spend_app/routers/router_name.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<CategoryProvider>().init();
    final categories = [
      {'asset': 'assets/images/ic_food.png', 'label': 'Food'},
      {'asset': 'assets/images/ic_transport.png', 'label': 'Transport'},
      {'asset': 'assets/images/ic_medicine.png', 'label': 'Medicine'},
      {'asset': 'assets/images/ic_groceries.png', 'label': 'Groceries'},
      {'asset': 'assets/images/ic_rent.png', 'label': 'Rent'},
      {'asset': 'assets/images/ic_gift.png', 'label': 'Gifts'},
      {'asset': 'assets/images/ic_savings.png', 'label': 'Savings'},
      {'asset': 'assets/images/ic_entertainment.png', 'label': 'Hobbies	'},
      {'asset': 'assets/images/ic_more.png', 'label': 'More'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xff00D09E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: null,
        title: Text(
          'Categories',
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
          // Header
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
                //thanh progress
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
                child: GridView.builder(
                  itemCount: categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 24.h,
                    crossAxisSpacing: 24.w,
                    childAspectRatio: 1,
                  ),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = categories[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouterName.categories,
                          arguments: {
                            'icon': item['asset'],
                            'label': item['label'],
                          },
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 80.w,
                            height: 80.w,
                            decoration: BoxDecoration(
                              color: const Color(0xff6DB6FE),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Center(
                              child: Image.asset(
                                item['asset'] as String,
                                width: 40.sp,
                                height: 40.sp,
                                color: const Color(0xffF1FFF3),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          SizedBox(
                            width: 80.w,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                item['label'] as String,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff093030),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: RootNavBar(currentIndex: 0),
    );
  }
}
