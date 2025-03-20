import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRouter.login,
        onGenerateRoute: AppRouter.onGenerateRoute,
      );
}
