import 'dart:io';

import 'package:driver_rating/Core/authentication.dart';
import 'package:driver_rating/Screens/AuthScreens/signIn.dart';
import 'package:driver_rating/Screens/home.dart';
import 'package:driver_rating/widgets/passwordField.dart';
import 'package:driver_rating/widgets/textfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController confirmController = TextEditingController();
var res;
bool imageSelected = false;
bool _isLoading = false;
bool isImageUploaded = false;

final _formkey = GlobalKey<FormState>();

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    emailController.clear();
    passwordController.clear();
    confirmController.clear();
    nameController.clear();
    imageSelected = false;
    _isLoading = false;
    // TODO: implement initState
    super.initState();
  }

  FirebaseStorage storage = FirebaseStorage.instance;
  var url = '';
  File? imageFile;
  var selectedImagePath = '';
  var selectedImageSize = '';
  Future getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        selectedImagePath = pickedFile.path;
        selectedImageSize =
            ((File(selectedImagePath)).lengthSync() / 1024 / 1024)
                    .toStringAsFixed(2) +
                " Mb";
      });

      uploadImageToFirebase();
    } else {
      // Get.snackbar("Error !", "No Photo Selected",
      //     backgroundColor: Colors.red,
      //     snackPosition: SnackPosition.TOP,
      //     colorText: Colors.black);
    }
  }

  Future uploadImageToFirebase() async {
    // showLoadingIndicator();
    Reference firebaseStorageRef =
        storage.ref().child('uploads/${selectedImagePath}');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile!);
    uploadTask.then((res) async {
      url = await res.ref.getDownloadURL();
      print(url);
      isImageUploaded = true;
      setState(() {});

      //hideLoadingIndicator();
    });
  }

  Authentications authentication = Authentications();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "SIGNUP",
                  //   style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      "Welcome to Driver Rating\nCreate a new account",
                      style: GoogleFonts.roboto(
                          fontSize: 20, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: imageFile == null
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: imageSelected == true
                                      ? imageFile == null
                                          ? Colors.red
                                          : Colors.black
                                      : Colors.black,
                                ),
                              ),
                              child: const Icon(Icons.add),
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: FileImage(imageFile!),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const Text("Name"),
                        // const SizedBox(
                        //   height: 8,
                        // ),
                        CustomTextField(
                          isIcon: true,
                          hintText: "Name",
                          maxLines: 1,
                          icon: Icons.person,
                          controller: nameController,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const Text("Email"),
                        // const SizedBox(
                        //   height: 8,
                        // ),
                        CustomTextField(
                          isIcon: true,
                          hintText: "Email",
                          maxLines: 1,
                          icon: Icons.email,
                          controller: emailController,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const Text("Password"),
                        // const SizedBox(
                        //   height: 8,
                        // ),
                        PasswordField(
                          hintText: "Password",
                          maxLines: 1,
                          icon: Icons.lock,
                          controller: passwordController,
                          confirmController: confirmController,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const Text("Confirm Password"),
                        // const SizedBox(
                        //   height: 8,
                        // ),
                        PasswordField(
                          hintText: "Confirm Password",
                          maxLines: 1,
                          icon: Icons.lock_open,
                          controller: confirmController,
                          confirmController: passwordController,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 30, bottom: 20),
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
                          onPressed: !isImageUploaded
                              ? null
                              : () {
                                  if (imageFile == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text("Please Select the Image"),
                                      ),
                                    );
                                  }
                                  if (_formkey.currentState!.validate() &&
                                      imageFile != null) {
                                    setState(() {
                                      imageSelected = true;
                                      _isLoading = true;
                                    });
                                    dynamic res = authentication.signUp(
                                        context,
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                        confirmController.text.trim(),
                                        url,
                                        nameController.text.trim());

                                    if (res == null) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  }
                                  setState(() {
                                    imageSelected = true;
                                  });
                                  // else {
                                  //   setState(() {
                                  //     _isLoading = false;
                                  //   });
                                  // }
                                },
                          child: const Text("SignUp")),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.offAll(const SignInScreen());
                    },
                    child: Text(
                      'login',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
