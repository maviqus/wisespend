import 'package:flutter/material.dart';
import 'package:wise_spend_app/modules/404/error_screen.dart';
import 'package:wise_spend_app/modules/add_expenses/screens/add_expenses_screen.dart';
import 'package:wise_spend_app/modules/authenticator/screens/forgot_password_screen.dart';
import 'package:wise_spend_app/modules/authenticator/screens/lauch_sceen.dart';
import 'package:wise_spend_app/modules/authenticator/screens/sign_in_screen.dart';
import 'package:wise_spend_app/modules/authenticator/screens/sign_up_screen.dart';
import 'package:wise_spend_app/modules/category/screens/categories_screen.dart';
import 'package:wise_spend_app/modules/category/screens/category_customization_screen.dart';
import 'package:wise_spend_app/modules/home/screens/home_screen.dart';
import 'package:wise_spend_app/modules/notification/screens/notification_screen.dart';
import 'package:wise_spend_app/modules/profile/screens/profile_screen.dart';
import 'package:wise_spend_app/modules/splash/splash_screen.dart';
import 'package:wise_spend_app/modules/welcome/screens/welcome_screen.dart';
import 'package:wise_spend_app/routers/router_name.dart';
import 'package:wise_spend_app/modules/analysis/screens/analysis_screen.dart';
import 'package:wise_spend_app/modules/transaction/screens/transaction_screen.dart';
import 'package:wise_spend_app/modules/authenticator/screens/recover_password_screen.dart';

class RouterCustom {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouterName.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouterName.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case RouterName.signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case RouterName.signin:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case RouterName.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case RouterName.recoverPassword:
        return MaterialPageRoute(builder: (_) => const RecoverPasswordScreen());
      case RouterName.home:
        return _createFadeRoute(const HomeScreen());
      case RouterName.categories:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => CategoriesScreen(
            label: args['label'] ?? '',
            categoryId: args['categoryId'] ?? '',
          ),
        );
      case RouterName.categoryCustomization:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => CategoryCustomizationScreen(
            categoryId: args['categoryId'] ?? '',
            categoryName: args['categoryName'] ?? '',
          ),
        );
      case RouterName.addExpenses:
        return _createFadeRoute(const AddExpenseScreen());
      case RouterName.notification:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case RouterName.profile:
        return _createFadeRoute(const ProfileScreen());
      case RouterName.lauch:
        return MaterialPageRoute(builder: (_) => const LauchSceen());
      case RouterName.analysis:
        return _createFadeRoute(const AnalysisScreen());
      case RouterName.transaction:
        return _createFadeRoute(const TransactionScreen());
      default:
        return MaterialPageRoute(builder: (_) => const ErrorScreen());
    }
  }

  static PageRouteBuilder _createFadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return FadeTransition(opacity: animation.drive(tween), child: child);
      },
    );
  }
}
