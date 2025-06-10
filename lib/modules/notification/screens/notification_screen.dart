import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wise_spend_app/core/widgets/root_navbar.widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'Reminder!',
        'description':
            'Set up your automatic savings to meet your savings goal...',
        'time': '17:00 - April 24',
        'date': 'Today',
        'icon': Icons.notifications,
      },
      {
        'title': 'New Update',
        'description':
            'Set up your automatic savings to meet your savings goal...',
        'time': '17:00 - April 24',
        'date': 'Today',
        'icon': Icons.update,
      },
      {
        'title': 'Transactions',
        'description': 'A new transaction has been registered',
        'time': '17:00 - April 24',
        'date': 'Yesterday',
        'icon': Icons.attach_money,
      },
      {
        'title': 'Reminder!',
        'description':
            'Set up your automatic savings to meet your savings goal...',
        'time': '17:00 - April 24',
        'date': 'Yesterday',
        'icon': Icons.notifications,
      },
      {
        'title': 'Expense Record',
        'description':
            'We recommend that you be more attentive to your finances.',
        'time': '17:00 - April 24',
        'date': 'This Weekend',
        'icon': Icons.trending_down,
      },
      {
        'title': 'Transactions',
        'description': 'A new transaction has been registered',
        'time': '17:00 - April 24',
        'date': 'This Weekend',
        'icon': Icons.attach_money,
      },
    ];

    final groupedNotifications = {};
    for (var notification in notifications) {
      final date = notification['date'];
      if (!groupedNotifications.containsKey(date)) {
        groupedNotifications[date] = [];
      }
      groupedNotifications[date].add(notification);
    }

    return Scaffold(
      backgroundColor: const Color(0xff00D09E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: const Color(0xff093030)),
        title: Text(
          'Notification',
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
        child: ListView(
          children: [
            for (var date in groupedNotifications.keys) ...[
              Text(
                date,
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff093030),
                ),
              ),
              SizedBox(height: 12.h),
              for (var notification in groupedNotifications[date]) ...[
                ListTile(
                  leading: Icon(
                    notification['icon'] as IconData,
                    color: const Color(0xff00D09E),
                    size: 32.sp,
                  ),
                  title: Text(
                    notification['title'],
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff093030),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification['description'],
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: const Color(0xff093030),
                        ),
                      ),
                      Text(
                        notification['time'],
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: const Color(0xff00D09E),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey.shade300, thickness: 1),
              ],
            ],
          ],
        ),
      ),
      bottomNavigationBar: RootNavBar(currentIndex: 0),
    );
  }
}
