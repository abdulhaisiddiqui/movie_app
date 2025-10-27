import 'package:flutter/material.dart';
import 'package:myapp/views/screens/Login_Signup/login_screen.dart';
import 'package:myapp/views/screens/Login_Signup/signup_screen.dart';
import 'package:myapp/views/screens/OnBoarding/onBoarding_screen.dart';

import 'package:myapp/views/screens/home/home_screen.dart';
import 'package:myapp/views/screens/specific/specific_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String onboarding = '/onboarding';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen()
        );
    }
  }
}
