import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/core/widgets/root_navbar.widget.dart';
import 'package:wise_spend_app/data/providers/notification_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).loadNotifications();
    });
  }

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'notifications':
        return Icons.notifications;
      case 'warning':
        return Icons.warning;
      case 'info':
        return Icons.info;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00D09E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Color(0xff093030)),
        title: Text(
          'Notifications',
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
        child: Consumer<NotificationProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(child: Text('Error: ${provider.error}'));
            }

            final groupedNotifications = provider.groupedNotifications;
            if (groupedNotifications.isEmpty) {
              return const Center(child: Text('No notifications available'));
            }

            return ListView.builder(
              itemCount: groupedNotifications.length,
              itemBuilder: (context, index) {
                final date = groupedNotifications.keys.toList()[index];
                final notificationsForDate = groupedNotifications[date] ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff093030),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ...notificationsForDate.map(
                      (notification) => NotificationItem(
                        notification: notification,
                        getIconData: _getIconData,
                      ),
                    ),
                    Divider(color: Colors.grey.shade300, thickness: 1),
                  ],
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const RootNavBar(currentIndex: 0),
    );
  }
}

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.notification,
    required this.getIconData,
  });

  final Map<String, dynamic> notification;
  final IconData Function(String?) getIconData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        getIconData(notification['icon'] as String?),
        color: const Color(0xff00D09E),
        size: 32.sp,
      ),
      title: Text(
        notification['title'] as String? ?? 'No Title',
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
            notification['description'] as String? ?? 'No Description',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: const Color(0xff093030),
            ),
          ),
          Text(
            notification['time'] as String? ?? 'No Time',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: const Color(0xff00D09E),
            ),
          ),
        ],
      ),
      onTap: () {},
    );
  }
}
