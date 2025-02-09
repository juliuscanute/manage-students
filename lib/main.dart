import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:managestudents/di.dart';
import 'package:managestudents/login_cubit.dart';
import 'package:managestudents/login_page.dart';
import 'package:managestudents/login_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env", isOptional: true);
  final config = await loadConfig();

  final mergedConfig = {
    'apiKey': dotenv.env['FIREBASE_API_KEY'] ?? config['apiKey']!,
    'authDomain': dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? config['authDomain']!,
    'projectId': dotenv.env['FIREBASE_PROJECT_ID'] ?? config['projectId']!,
    'storageBucket':
        dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? config['storageBucket']!,
    'messagingSenderId': dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ??
        config['messagingSenderId']!,
    'appId': dotenv.env['FIREBASE_APP_ID'] ?? config['appId']!,
    'measurementId':
        dotenv.env['FIREBASE_MEASUREMENT_ID'] ?? config['measurementId']!,
  };

  await setupInjection(mergedConfig);

  final loginRepository = LoginRepository(getIt());
  runApp(MyApp(loginRepository: loginRepository));
}

class MyApp extends StatelessWidget {
  final LoginRepository loginRepository;

  const MyApp({Key? key, required this.loginRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => LoginCubit(loginRepository),
        child: const LoginPage(),
      ),
    );
  }
}

Future<Map<String, dynamic>> loadConfig() async {
  try {
    final response = await http.get(Uri.parse('config.json'));
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      print('Failed to load config.json: ${response.statusCode}');
    }
  } catch (e) {
    print('An error occurred while loading config.json: $e');
  }
  return {};
}
