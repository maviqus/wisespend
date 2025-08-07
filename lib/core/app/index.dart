import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:wise_spend_app/core/utils/theme.dart';
import 'package:wise_spend_app/data/providers/add_expenses_provider.dart';
import 'package:wise_spend_app/data/providers/category_provider.dart';
import 'package:wise_spend_app/data/providers/more_provider.dart';
import 'package:wise_spend_app/data/providers/notification_provider.dart';
import 'package:wise_spend_app/data/providers/remove_provider.dart';
import 'package:wise_spend_app/modules/home/providers/home_provider.dart';
import 'package:wise_spend_app/routers/router_custom.dart';
import 'package:wise_spend_app/data/providers/save_data_provider.dart';
import 'package:wise_spend_app/data/providers/get_data_provider.dart';
import 'package:wise_spend_app/data/providers/total_provider.dart';
import 'package:wise_spend_app/modules/profile/providers/profile_provider.dart';
import 'package:wise_spend_app/modules/authenticator/providers/forgot_password_provider.dart';
import 'package:wise_spend_app/modules/authenticator/providers/sign_in_provier.dart';
import 'package:wise_spend_app/modules/authenticator/providers/sign_up_provider.dart';
import 'package:wise_spend_app/data/providers/analysis_provider.dart';
import 'package:wise_spend_app/routers/router_name.dart';

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
            ChangeNotifierProvider(create: (_) => MoreProvider()),
            ChangeNotifierProvider(create: (_) => RemoveProvider()),
            ChangeNotifierProvider(create: (_) => AddExpensesProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
            ChangeNotifierProvider(create: (_) => TotalProvider()),
            ChangeNotifierProvider(create: (_) => HomeProvider()),
            ChangeNotifierProvider(create: (_) => ProfileProvider()),
            ChangeNotifierProvider(create: (_) => SignInProvider()),
            ChangeNotifierProvider(
              create: (_) => ForgotPasswordProvider(),
            ), // Add this provider
            ChangeNotifierProvider(create: (_) => SignUpProvider()),
            ChangeNotifierProvider(create: (_) => AnalysisProvider()),
          ],
          child: ToastificationWrapper(
            config: const ToastificationConfig(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: RouterName.splash,
              onGenerateRoute: RouterCustom.onGenerateRoute,
              theme: AppTheme.lightTheme,
              // Add this to ensure sign in screen is rebuilt from scratch
              navigatorKey: GlobalKey<NavigatorState>(),
            ),
          ),
        );
      },
    );
  }
}
