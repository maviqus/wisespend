import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wise_spend_app/core/widgets/bottom_nav_icon_widget.dart';
import 'package:wise_spend_app/routers/router_name.dart';

class RootNavBar extends StatelessWidget {
  final int currentIndex;

  const RootNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'asset': 'assets/images/ic_home.png',
        'onTap': () => Navigator.pushReplacementNamed(context, RouterName.home),
      },
      {
        'asset': 'assets/images/ic_analysis.png',
        'onTap': () =>
            Navigator.pushReplacementNamed(context, RouterName.analysis),
      },
      {
        'asset': 'assets/images/ic_transaction.png',
        'onTap': () =>
            Navigator.pushReplacementNamed(context, RouterName.transaction),
      },
      {
        'asset': 'assets/images/ic_layers.png',
        'onTap': () =>
            Navigator.pushReplacementNamed(context, RouterName.categories),
      },
      {
        'asset': 'assets/images/ic_profile.png',
        'onTap': () =>
            Navigator.pushReplacementNamed(context, RouterName.profile),
      },
    ];

    return Container(
      decoration: BoxDecoration(color: Color(0xffF1FFF3)),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffDFF7E2),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            return BottomNavIcon(
              asset: items[i]['asset'] as String,
              isActive: i == currentIndex,
              onTap: items[i]['onTap'] as VoidCallback,
            );
          }),
        ),
      ),
    );
  }
}
