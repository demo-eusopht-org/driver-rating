import 'package:driver_rating/Screens/AuthScreens/forgot_screen.dart';
import 'package:driver_rating/Screens/AuthScreens/signup.dart';
import 'package:driver_rating/widgets/passwordField.dart';
import 'package:driver_rating/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/authentication.dart';
import '../../widgets/loginfield.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
final _formkey = GlobalKey<FormState>();
bool formKeyDispose = false;
Authentications authentication = Authentications();

class _SignInScreenState extends State<SignInScreen> {
  bool _isLoading = false;
  var res;

  void initState() {
    emailController.clear();
    passwordController.clear();

    _isLoading = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        // margin: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text(
                  //   "SIGNIN",
                  //   style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                  // ),
                  Container(
                    margin: EdgeInsets.only(top: 90),
                    height: height * 0.25,
                    // width: 140,
                    child: Image(
                      image: AssetImage('images/1.png'),
                    ),
                  ),

                  Text(
                    "Welcome back!",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Log into your account and get started!",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const Text("Email"),
                        // const SizedBox(
                        //   height: 8,
                        // ),
                        CustomTextField(
                          hintText: "Email",
                          isIcon: true,
                          maxLines: 1,
                          icon: Icons.email,
                          controller: emailController,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const Text("Password"),
                        // const SizedBox(
                        //   height: 8,
                        // ),
                        LoginPasswordField(
                          hintText: "Password",
                          maxLines: 1,
                          icon: Icons.lock,
                          controller: passwordController,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(ForgotPasswordScreen());
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.07,
                child: _isLoading == true
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                        ),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });

                            dynamic res = await authentication.signIn(
                              context,
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
                            if (res == null) {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }
                        },
                        child: const Text("LOGIN"),
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have account?",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: () {
                      // setState(() {
                      //   // formKeyDispose = true;
                      //   // _formkey.currentState!.deactivate();
                      // });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: Colors.blue),
                    ),
                  ),
                ],
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   height: MediaQuery.of(context).size.height * 0.07,
              //   child: ElevatedButton(
              //     onPressed: () {

              //     },
              //     child: const Text("SignIn"),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
