import 'package:flutter/material.dart';
import 'package:queueless_flutter/screens/splash_screen.dart';
import 'package:queueless_flutter/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:queueless_flutter/services/firestore_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    await FirestoreService().seedDummyData();
  } catch (e) {
    debugPrint('Error seeding dummy data: $e');
  }
  runApp(const QueueLessApp());
}

class QueueLessApp extends StatelessWidget {
  const QueueLessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QueueLess',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
