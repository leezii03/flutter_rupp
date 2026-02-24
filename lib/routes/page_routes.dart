import 'package:flutter/material.dart';
import 'package:flutter_assignment/routes/app_routes.dart';
import 'package:flutter_assignment/routes/page_transition.dart';
import 'package:flutter_assignment/screens/details_screen/details_screen.dart';
import 'package:flutter_assignment/screens/login_screen/login_screen.dart';
import 'package:flutter_assignment/screens/onboard_screen/onboard_screen.dart';
import 'package:flutter_assignment/screens/register_screen/register_screen.dart';
import 'package:flutter_assignment/screens/search_screen/search_screen.dart';
import 'package:flutter_assignment/screens/splash_screen/splash_screen.dart';
import 'package:flutter_assignment/widgets/mainscreen.dart';

class PageRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return PageTransition.build(
          page: SplashScreen(),
          settings: settings,
        );
      case AppRoutes.onboard:
        return PageTransition.build(
          page: OnboardScreen(),
          settings: settings,
          transition: PageTransitionType.circleReveal,
          duration: Duration(seconds: 1),
        );
      case AppRoutes.login:
        return PageTransition.build(
          page: LoginScreen(),
          settings: settings,
        );
      case AppRoutes.register:
        return PageTransition.build(
          page: RegisterScreen(),
          settings: settings,
          transition: PageTransitionType.none,
        );
      case AppRoutes.main:
        return PageTransition.build(
          page: Mainscreen(),
          settings: settings,
        );
      case AppRoutes.details:
        final post = settings.arguments as Map<String, dynamic>;
        return PageTransition.build(
          page: DetailsScreen(
            post: post,
          ),
          settings: settings,
        );
      case AppRoutes.search:
        return PageTransition.build(
          page: SearchScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text("Route not found!"),
            ),
          ),
        );
    }
  }
}
