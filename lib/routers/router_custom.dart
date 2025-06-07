import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/modules/404/error_screen.dart';
import 'package:wise_spend_app/modules/authenticator/providers/forgot_password_provider.dart';
import 'package:wise_spend_app/modules/authenticator/screens/forgot_password_screen.dart';
import 'package:wise_spend_app/modules/authenticator/screens/lauch_sceen.dart';
import 'package:wise_spend_app/modules/authenticator/screens/sign_in_screen.dart';
import 'package:wise_spend_app/modules/authenticator/screens/sign_up_screen.dart';
import 'package:wise_spend_app/modules/home/screens/home_screen.dart';
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
        return PageTransition(
          type: PageTransitionType.fade,
          child: const SignInScreen(),
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
      default:
        return MaterialPageRoute(builder: (_) => const ErrorScreen());
    }
  }
}
