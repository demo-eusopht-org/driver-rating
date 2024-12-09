import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_rating/Core/authentication.dart';
import 'package:driver_rating/Screens/AuthScreens/signIn.dart';
import 'package:driver_rating/Screens/commenting_screen.dart';
import 'package:driver_rating/Screens/indo_add.dart';
import 'package:driver_rating/main.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              child: Icon(Icons.logout),
              onPressed: () {
                authentication.logOut(context);
              }),
          SizedBox(
            height: 10,
          ),
          Container(
            height: height * 0.1,
            width: width * 0.2,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .where('uid',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      height: height * 0.1,
                      width: width * 0.2,
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            if (snapshot.hasData) {
                              Map<String, dynamic> data =
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;
                              log('PHOTO: ${data['photo']}');
                              return FloatingActionButton(
                                  child: const Icon(Icons.add),
                                  onPressed: () {
                                    Get.to(
                                      InfoAddScreen(
                                        postUser: 'Bye',
                                        userImage: data['photo'],
                                      ),
                                    );
                                  });
                            } else {
                              return Container();
                            }
                          }),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: const CircularProgressIndicator());
              } else {
                return Container(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> postData =
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                        log('PICTURE: ${postData["post"]} ${postData["postTitle"]}');
                        return GestureDetector(
                          onTap: () {
                            Get.to(CommentingScreen(
                              image: postData["post"],
                              imageName: postData["postTitle"],
                              imagedes: postData["postdes"],
                              postratng: postData['rating'],
                              // postUser: postData['username'],
                              // postUserId: postData['userId'],
                              // postUserPic: postData['userpic'],
                              postId: snapshot.data!.docs[index].data(),
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: postData["post"],
                                      placeholder: ((context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator())),
                                      errorWidget: ((context, url, error) =>
                                          const Icon(
                                            Icons.error,
                                            color: Colors.black,
                                          )),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.35,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    )),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                          onTap: () {},
                                          child: const Icon(
                                            FeatherIcons.messageCircle,
                                            color: Colors.black,
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('posts')
                                              .doc(postData['postId'])
                                              .collection('comments')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                "${snapshot.data!.docs.length} comments",
                                                style: GoogleFonts.roboto(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              );
                                            } else {
                                              return Text('0');
                                            }
                                          })
                                    ],
                                  ),
                                ),

                                RatingBar.builder(
                                  initialRating: postData["rating"],
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  itemSize: 20,
                                  ignoreGestures: true,
                                  onRatingUpdate: (rating) {},
                                ),

                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        postData["postTitle"],
                                        style: GoogleFonts.roboto(
                                            fontSize: 22,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        postData["postdes"],
                                        style: GoogleFonts.roboto(
                                          color: Colors.black.withOpacity(0.8),
                                          fontWeight: FontWeight.w300,
                                        ),
                                        maxLines: 3,
                                      ),
                                    ],
                                  ),
                                ),
                                // Text("${postData["postTitle"]}"),
                                // Text("${postData["postdes"]}")
                              ],
                            ),
                          ),
                        );
                      }),
                );
              }
            }),
      ),
    );
  }
}

User? currentusers = FirebaseAuth.instance.currentUser;
