import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:managestudents/blocs/class_cubit.dart';
import 'package:managestudents/blocs/login_cubit.dart';
import 'package:managestudents/blocs/student_cubit.dart';
import 'package:managestudents/config/app_router.dart';
import 'package:managestudents/repository/class_repository.dart';
import 'package:managestudents/repository/login_repository.dart';
import 'package:managestudents/repository/student_repository.dart';

final getIt = GetIt.instance;

Future<void> setupInjection(Map<String, dynamic> config) async {
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: config['apiKey']!,
      authDomain: config['authDomain']!,
      projectId: config['projectId']!,
      storageBucket: config['storageBucket']!,
      messagingSenderId: config['messagingSenderId']!,
      appId: config['appId']!,
      measurementId: config['measurementId']!,
    ),
  );

  // Register FirebaseAuth instance
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Register Firestore instance
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);

  // Register repositories
  getIt.registerLazySingleton<LoginRepository>(() => LoginRepository(getIt()));
  getIt.registerLazySingleton<ClassRepository>(() => ClassRepository());
  getIt.registerLazySingleton<StudentRepository>(() => StudentRepository());

  // Register cubits
  getIt.registerLazySingleton<LoginCubit>(() => LoginCubit(getIt()));
  getIt.registerLazySingleton<ClassCubit>(() => ClassCubit(getIt()));
  getIt.registerLazySingleton<StudentCubit>(() => StudentCubit(getIt()));

  // Register AppRouter instance
  getIt.registerLazySingleton<AppRouter>(() => AppRouter());
}
