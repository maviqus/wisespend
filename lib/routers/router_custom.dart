import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/core/services/share_preferences_service.dart';
import 'package:wise_spend_app/modules/404/error_screen.dart';
import 'package:wise_spend_app/modules/authenticator/providers/forgot_password_provider.dart';
import 'package:wise_spend_app/modules/authenticator/screens/forgot_password_screen.dart';
import 'package:wise_spend_app/modules/authenticator/screens/lauch_sceen.dart';
import 'package:wise_spend_app/modules/authenticator/screens/sign_in_screen.dart';
import 'package:wise_spend_app/modules/authenticator/screens/sign_up_screen.dart';
import 'package:wise_spend_app/modules/category/screens/categories_screen.dart';
import 'package:wise_spend_app/modules/home/screens/home_screen.dart';
import 'package:wise_spend_app/modules/notification/screens/notification_screen.dart';
import 'package:wise_spend_app/modules/splash/splash_screen.dart';
import 'package:wise_spend_app/modules/welcome/screens/welcome_screen.dart';
import 'package:wise_spend_app/routers/router_name.dart';

class RouterCustom {
  static const String initial = RouterName.splash;

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouterName.splash:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const SplashScreen(),
        );
      case RouterName.welcome:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const WelcomeScreen(),
        );
      case RouterName.signin:
        // token = shars
        return PageTransition(
          type: PageTransitionType.fade,
          // child: token ? HomeScreen() : SignInScreen(),
          child: SignInScreen(),
        );
      case RouterName.signup:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const SignUpScreen(),
        );
      case RouterName.home:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const HomeScreen(),
        );
      case RouterName.lauch:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const LauchSceen(),
        );
      case RouterName.forgotPassword:
        return PageTransition(
          type: PageTransitionType.fade,
          child: ChangeNotifierProvider(
            create: (context) => ForgotPasswordProvider(),
            child: const ForgotPasswordScreen(),
          ),
        );
      case RouterName.categories:
        final args = settings.arguments as Map<String, dynamic>?;
        return PageTransition(
          type: PageTransitionType.fade,
          child: CategoriesScreen(icon: args?['icon'], label: args?['label']),
        );
      case RouterName.notification:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const NotificationScreen(),
        );
      default:
        return MaterialPageRoute(builder: (_) => const ErrorScreen());
    }
  }
}
