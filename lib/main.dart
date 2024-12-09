import 'package:driver_rating/Screens/AuthScreens/signup.dart';
import 'package:driver_rating/Screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Screens/AuthScreens/signIn.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const DriverRating());
}

class DriverRating extends StatefulWidget {
  const DriverRating({super.key});

  @override
  State<DriverRating> createState() => _DriverRatingState();
}

User? users = FirebaseAuth.instance.currentUser;

class _DriverRatingState extends State<DriverRating> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      home: users != null ? const Home() : const SignInScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
