import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/core/routes/app_routes.dart';
import 'package:myapp/services/firebase_auth_service.dart';
import 'package:myapp/views/screens/OnBoarding/onBoarding_screen.dart';
import 'package:myapp/viewmodels/providers/show_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';



void main()async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => FirebaseAuthService()),
    ChangeNotifierProvider(create: (_) => ShowProvider())
  ],
    child: MyApp(),
  ));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
