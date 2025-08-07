import 'package:flutter/material.dart';
import 'package:wise_spend_app/modules/404/error_screen.dart';
import 'package:wise_spend_app/modules/add_expenses/screens/add_expenses_screen.dart';
import 'package:wise_spend_app/modules/authenticator/screens/forgot_password_screen.dart';
import 'package:wise_spend_app/modules/authenticator/screens/lauch_sceen.dart';
import 'package:wise_spend_app/modules/authenticator/screens/sign_in_screen.dart';
import 'package:wise_spend_app/modules/authenticator/screens/sign_up_screen.dart';
import 'package:wise_spend_app/modules/category/screens/categories_screen.dart';
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
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case RouterName.categories:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => CategoriesScreen(
            label: args['label'] ?? '',
            categoryId: args['categoryId'] ?? '',
          ),
        );
      case RouterName.addExpenses:
        return MaterialPageRoute(
          builder: (_) => const AddExpenseScreen(),
          settings: settings,
        );
      case RouterName.notification:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case RouterName.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case RouterName.launch:
        return MaterialPageRoute(builder: (_) => const LauchSceen());
      case RouterName.analysis:
        return MaterialPageRoute(builder: (_) => const AnalysisScreen());
      case RouterName.transaction:
        return MaterialPageRoute(builder: (_) => const TransactionScreen());
      default:
        return MaterialPageRoute(builder: (_) => const ErrorScreen());
    }
  }
}
      case RouterName.signup:
        return FadePageRoute(child: const SignUpScreen(), settings: settings);
      case RouterName.forgotPassword:
        return FadePageRoute(
          child: const ForgotPasswordScreen(),
          settings: settings,
        );
      case RouterName.recoverPassword:
        return FadePageRoute(
          child: const RecoverPasswordScreen(),
          settings: settings,
        );
      case RouterName.lauch:
        return FadePageRoute(child: const LauchSceen(), settings: settings);
      case RouterName.editProfile:
        return MaterialPageRoute(builder: (_) => EditProfileScreen());
      default:
        return FadePageRoute(child: const ErrorScreen(), settings: settings);
    }
  }
}
