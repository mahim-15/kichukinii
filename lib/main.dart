// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:kichukini/authScreen/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kichukini/firebase_options.dart';
import 'package:kichukini/global/global.dart';
import 'package:kichukini/mainScreen/home_screen.dart';
import 'package:kichukini/splashScreen/my_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences =await SharedPreferences.getInstance();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KICHUKINI app',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      home: MySplashScreen(),
    );
  }
}

