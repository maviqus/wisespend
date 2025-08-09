import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wise_spend_app/routers/router_name.dart';

class RootNavBar extends StatelessWidget {
  final int currentIndex;

  const RootNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: const Color(0xfffdff7e2),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, -2),
            blurRadius: 20,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main navigation items
          Positioned.fill(
            child: Row(
              children: [
                Expanded(
                  child: _buildNavItem(
                    context,
                    index: 0,
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    route: RouterName.home,
                    label: 'Home',
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    context,
                    index: 1,
                    icon: Icons.analytics_outlined,
                    activeIcon: Icons.analytics,
                    route: RouterName.analysis,
                    label: 'Thống kê',
                  ),
                ),
                // Spacing for the center button
                SizedBox(width: 70.w),
                Expanded(
                  child: _buildNavItem(
                    context,
                    index: 3,
                    icon: Icons.receipt_long_outlined,
                    activeIcon: Icons.receipt_long,
                    route: RouterName.transaction,
                    label: 'Lịch sử',
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    context,
                    index: 4,
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    route: RouterName.profile,
                    label: 'Profile',
                  ),
                ),
              ],
            ),
          ),
          // Center Add Button
          Positioned(
            top: 10.h,
            left: MediaQuery.of(context).size.width / 2 - 30.w,
            child: _buildCenterAddButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String route,
    required String label,
  }) {
    final bool isActive = index == currentIndex;

    return InkWell(
      onTap: () {
        if (index != currentIndex) {
          _navigateWithFade(context, route);
        }
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xff00D09E).withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                isActive ? activeIcon : icon,
                color: isActive
                    ? const Color(0xff00D09E)
                    : Colors.grey.shade600,
                size: 24.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive
                    ? const Color(0xff00D09E)
                    : Colors.grey.shade600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _navigateWithFade(context, RouterName.addExpenses);
      },
      child: Container(
        width: 60.w,
        height: 60.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xff00D09E), const Color(0xff00B085)],
          ),
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff00D09E).withValues(alpha: 0.3),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(Icons.add, color: Colors.white, size: 28.sp),
      ),
    );
  }

  void _navigateWithFade(BuildContext context, String routeName) {
    if (routeName == RouterName.addExpenses) {
      Navigator.pushNamed(context, routeName);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, routeName, (r) => false);
    }
  }
}
