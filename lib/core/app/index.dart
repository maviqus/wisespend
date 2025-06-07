import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import 'package:wise_spend_app/core/utils/theme.dart';
import 'package:wise_spend_app/routers/router_custom.dart';

class Index extends StatelessWidget {
  const Index({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ToastificationConfigProvider(
          config: const ToastificationConfig(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: RouterCustom.initial,
            onGenerateRoute: RouterCustom.onGenerateRoute,
            theme: AppTheme.lightTheme,
          ),
        );
      },
    );
  }
}
