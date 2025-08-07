import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wise_spend_app/routers/router_name.dart';

class RootNavBar extends StatelessWidget {
  final int currentIndex;

  const RootNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76.h,
      decoration: BoxDecoration(
        color: Color(0xffDFF7E2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            index: 0,
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            route: RouterName.home,
          ),
          _buildNavItem(
            context,
            index: 1,
            icon: Icons.bar_chart_outlined,
            activeIcon: Icons.bar_chart,
            route: RouterName.analysis,
          ),
          _buildNavItem(
            context,
            index: 2,
            icon: Icons.account_balance_wallet_outlined,
            activeIcon: Icons.account_balance_wallet,
            route: RouterName.transaction,
          ),
          _buildNavItem(
            context,
            index: 3,
            icon: Icons.add_circle_outline,
            activeIcon: Icons.add_circle,
            route: RouterName.addExpenses,
          ),
          _buildNavItem(
            context,
            index: 4,
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            route: RouterName.profile,
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
  }) {
    final bool isActive = index == currentIndex;

    return InkWell(
      onTap: () {
        if (index != currentIndex) {
          Navigator.pushNamedAndRemoveUntil(context, route, (r) => false);
        }
      },
      child: SizedBox(
        width: 70.w,
        child: Center(
          child: Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xff00D09E) : Colors.transparent,
              borderRadius: BorderRadius.circular(24.r), // More rounded corners
            ),
            child: Icon(
              isActive ? activeIcon : icon,
              color: isActive ? Colors.white : Colors.grey,
              size: 24.sp,
            ),
          ),
        ),
      ),
    );
  }
}
