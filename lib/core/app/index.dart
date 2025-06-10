import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:wise_spend_app/core/utils/theme.dart';
import 'package:wise_spend_app/data/providers/category_provider.dart';
import 'package:wise_spend_app/routers/router_custom.dart';
import 'package:wise_spend_app/data/providers/save_data_provider.dart';
import 'package:wise_spend_app/data/providers/get_data_provider.dart';

class Index extends StatelessWidget {
  const Index({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SaveDataProvider()),
            ChangeNotifierProvider(create: (_) => GetDataProvider()),
            ChangeNotifierProvider(create: (_) => CategoryProvider()..init()),
          ],
          child: ToastificationConfigProvider(
            config: const ToastificationConfig(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: RouterCustom.initial,
              onGenerateRoute: RouterCustom.onGenerateRoute,
              theme: AppTheme.lightTheme,
            ),
          ),
        );
      },
    );
  }
}
