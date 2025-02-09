import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
}
