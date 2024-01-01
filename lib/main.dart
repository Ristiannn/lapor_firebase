import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lapor_firebase/firebase_options.dart';
import 'package:lapor_firebase/pages/RegisterPage.dart';
import 'package:lapor_firebase/pages/SplashPage.dart';
import 'package:lapor_firebase/pages/dashboard/DashboardPage.dart';
import 'package:lapor_firebase/pages/LoginPage.dart';
import 'package:lapor_firebase/pages/AddFormPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
      title: 'Lapor Book',
    initialRoute: '/',
    routes: {
      '/': (context) => SplashPage(),
      '/login': (context) =>  LoginPage(),
      '/register': (context) => const RegisterPage(),
      '/dashboard': (context) => const DashboardPage(),
      '/add': (context) => AddFormPage(),
      // '/detail': (context) => DetailPage(),
    },
  ));
}
