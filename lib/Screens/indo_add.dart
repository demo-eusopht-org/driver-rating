import 'dart:io';

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_rating/widgets/textfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../Core/database.dart';

class InfoAddScreen extends StatefulWidget {
  final String? postUser;
  final String? userImage;
  InfoAddScreen({super.key, this.postUser, this.userImage});

  @override
  State<InfoAddScreen> createState() => _InfoAddScreenState();
}

class _InfoAddScreenState extends State<InfoAddScreen> {
  DriverRatingDatabase driverRatingDatabase = DriverRatingDatabase();
  final formkey = GlobalKey<FormState>();
  TextEditingController firstFieldController = TextEditingController();

  TextEditingController secondFieldController = TextEditingController();
  bool imageSelected = false;
  bool isImageUploaded = false;
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
    await uploadTask.then((res) async {
      url = await res.ref.getDownloadURL();
      print(url);
      isImageUploaded = true;
      setState(() {});

      //hideLoadingIndicator();
    });
  }

  double? ratingStar = 0;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 0, right: 0, top: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: imageFile == null
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10)),
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width,
                            child: const Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(10)),
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: MediaQuery.of(context).size.width,
                              child: Image(
                                image: FileImage(imageFile!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Form(
                        key: formkey,
                        child: Column(
                          children: [
                            CustomTextField(
                              isIcon: false,
                              controller: firstFieldController,
                              maxLines: 1,
                              hintText: 'Title',
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            CustomTextField(
                              isIcon: false,
                              controller: secondFieldController,
                              maxLines: 10,
                              hintText: 'Description',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: RatingBar.builder(
                          initialRating: 0,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              ratingStar = rating;
                            });
                          },
                        ),
                      ),
                      Container(
                        height: height * 0.06,
                        width: width * 0.5,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: !isImageUploaded
                                ? null
                                : () {
                                    if (imageFile == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar( 
                                        SnackBar(
                                          content:
                                              Text("Please Select the Image"),
                                        ),
                                      );
                                    }
                                    if (formkey.currentState!.validate() &&
                                        imageFile != null) {
                                      setState(() {
                                        imageSelected = true;
                                      });
                                      driverRatingDatabase.uploadPost(
                                          createdAt: Timestamp.now(),
                                          rating: ratingStar == null
                                              ? 0
                                              : ratingStar!.toDouble(),
                                          context: context,
                                          des: secondFieldController.text,
                                          post: url,
                                          title: firstFieldController.text,
                                          userImage:
                                              widget.userImage.toString(),
                                          userName: widget.postUser.toString());
                                      Navigator.pop(context);
                                    } else {
                                      // ScaffoldMessenger.of(context).showSnackBar(
                                      //     const SnackBar(content: Text('Error')));
                                    }
                                  },
                            child: const Text('Upload')),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
