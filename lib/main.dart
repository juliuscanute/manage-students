import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:managestudents/blocs/class_cubit.dart';
import 'package:managestudents/blocs/student_cubit.dart';
import 'package:managestudents/config/app_config.dart';
import 'package:managestudents/config/app_router.dart';
import 'package:managestudents/config/di.dart';
import 'package:managestudents/blocs/login_cubit.dart';
import 'package:managestudents/screens/home_page.dart';
import 'package:managestudents/screens/login_page.dart';

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

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = getIt<AppRouter>();

  final LoginCubit cubit = getIt<LoginCubit>();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LoginCubit>()),
        BlocProvider(create: (_) => getIt<ClassCubit>()),
        BlocProvider(create: (_) => getIt<StudentCubit>()),
      ],
      child: MaterialApp(
        home: _getInitialPage(),
        onGenerateRoute: _appRouter.generateRoute,
      ),
    );
  }

  Widget _getInitialPage() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
