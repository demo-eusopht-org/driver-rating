import 'package:driver_rating/Screens/AuthScreens/signIn.dart';
import 'package:flutter/material.dart';

import '../../widgets/textfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final _formkeyForgot = GlobalKey<FormState>();
  TextEditingController emailforgotController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formkeyForgot,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const s
                  CustomTextField(
                      isIcon: true,
                      hintText: "Email",
                      maxLines: 1,
                      icon: Icons.email,
                      controller: emailforgotController),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.07,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                onPressed: () {
                  if (_formkeyForgot.currentState!.validate()) {
                    authentication.resetPassword(
                        context, emailforgotController.text);
                  } else {}
                },
                child: const Text("SignIn"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
