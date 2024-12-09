import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_rating/Screens/AuthScreens/signIn.dart';
import 'package:driver_rating/Screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_loader_overlay/progress_loader_overlay.dart';

import '../Model/userModel.dart';

class Authentications {
  bool _isLoading = false;
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<void> createDatabase(UserModel user, User firestoreUser) async {
    await _db.collection("Users").doc('${firestoreUser.uid}').set(user.toMap());
  }

  signUp(
    BuildContext context,
    String email,
    String password,
    String confimPassword,
    String url,
    // String uid,
    String name,
  ) async {
    // await ProgressLoader().show(context);
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        UserModel userModel = UserModel(
          email: value.user!.email,
          name: name,
          uid: value.user!.uid,
          photo: url,
        );

        // ProgressLoader().dismiss();
        await createDatabase(userModel, value.user!)
            .then((value) => Get.offAll(Home()));
      });
    } catch (e) {
      // ProgressLoader().dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${(e as FirebaseAuthException).message}'),
        ),
      );
    }
  }

  signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then(
            (value) => Get.off(
              const Home(),
            ),
          );

      emailController.clear();
      passwordController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${(e as FirebaseAuthException).message}'),
        ),
      );
    }
  }

  logOut(BuildContext context) async {
    try {
      await auth.signOut().then(
            (value) => Get.off(
              const SignInScreen(),
            ),
          );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e'),
        ),
      );
    }
  }

  resetPassword(BuildContext context, String email) {
    try {
      auth
          .sendPasswordResetEmail(email: email)
          .then((value) => Get.off(SignInScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${(e as FirebaseAuthException).message}'),
      ));
    }
    ;
  }
}
