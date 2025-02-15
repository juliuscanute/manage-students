import 'package:flutter/material.dart';
import 'package:managestudents/deck/category_screen_subfolder_new.dart';
import 'package:managestudents/models/class_data.dart';
import 'package:managestudents/models/student_data.dart';
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
        final args = settings.arguments as Class?;
        return MaterialPageRoute(
            builder: (_) => ClassFormPage(classItem: args));
      case '/student':
        final args = settings.arguments as Student?;
        return MaterialPageRoute(
            builder: (_) => StudentFormPage(student: args));
      case '/category-screen-new':
        final args = settings.arguments as Map<String, dynamic>;
        final parentPath = args['parentPath'] as String;
        final subFolders = args['subFolders'] as List<Map<String, dynamic>>;
        final parentId = args['folderId'] as String;
        return MaterialPageRoute(
          builder: (_) => SubfolderScreen(
            parentFolderName: parentId,
            parentPath: parentPath,
            subFolders: subFolders,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
