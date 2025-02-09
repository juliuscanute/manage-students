import 'package:flutter/material.dart';
import 'package:managestudents/screens/class_page.dart';
import 'package:managestudents/screens/home_page.dart';
import 'package:managestudents/screens/login_page.dart';
import 'package:managestudents/screens/students_page.dart';

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/class':
        return MaterialPageRoute(builder: (_) => const CreateClassPage());
      case '/student':
        return MaterialPageRoute(builder: (_) => const CreateStudentPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
