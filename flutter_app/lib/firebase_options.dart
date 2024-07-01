import 'package:firebase_core/firebase_core.dart';

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      appId: 'your_app_id',
      apiKey: 'your_api_key',
      projectId: 'your_project_id',
      messagingSenderId: 'your_messaging_sender_id',
      storageBucket: 'your_storage_bucket',
      measurementId: 'your_measurement_id',
    ),
  );
}
