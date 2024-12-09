import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_rating/main.dart';
import 'package:driver_rating/widgets/textfield.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;

import '../Core/database.dart';

class CommentingScreen extends StatefulWidget {
  final postId;
  final String image;
  final String imageName;
  final String imagedes;
  final double postratng;
  // final String postUser;
  // final String postUserPic;
  // final String postUserId;
  const CommentingScreen({
    super.key,
    required this.image,
    required this.imageName,
    this.postId,
    required this.imagedes,
    required this.postratng,
    // required this.postUser,
    // required this.postUserPic,
    // required this.postUserId
  });

  @override
  State<CommentingScreen> createState() => _CommentingScreenState();
}

final _commentformkey = GlobalKey<FormState>();

TextEditingController commentController = TextEditingController();

int commentLen = 0;
bool keyboardheight = false;
bool showCommentstar = false;
double ratingStar = 0;
bool starReset = false;

String? notesUpdate;
String? putvalueUpdate;

class _CommentingScreenState extends State<CommentingScreen> {
  void postComment(
    String uid,
    String name,
    String profilePic,
    TextEditingController commentingController,
  ) async {
    try {
      String res = await DriverRatingDatabase().postComment(
        context,
        widget.postId['postId'],
        commentingController.text,
        uid,
        name,
        profilePic,
        ratingStar.toDouble(),
      );

      if (res != 'success') {
        // showSnackBar(context, res);
      }
      setState(() {
        commentLen++;
        commentController.text = "";
        log('send button');
        setState(() {
          ratingStar = 0.0;
        });
      });
    } catch (err) {
      // showSnackBar(
      //   context,
      //   err.toString(),
      // );
    }
  }

  final TextEditingController _controller = TextEditingController();
  bool emojiShowing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ratingStar = 0;
    showCommentstar = false;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (showCommentstar) {
            showCommentstar = false;
            setState(() {});
            return false;
          }
          if (emojiShowing) {
            emojiShowing = false;

            setState(() {});
            return false;
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              showCommentstar == true
                  ? Padding(
                      padding: const EdgeInsets.only(left: 5, right: 7, top: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                          child: RatingBar.builder(
                            itemSize: 45,
                            initialRating: ratingStar,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                ratingStar = rating;
                                // ratingStar = rating;
                                // starReset == true ? rating = 0 : rating;
                              });
                            },
                          ),
                        ),
                        // child: CachedNetworkImage(
                        //   imageUrl: widget.image,
                        //   placeholder: ((context, url) =>
                        //       const Center(child: CircularProgressIndicator())),
                        //   errorWidget: ((context, url, error) => const Icon(
                        //         Icons.error,
                        //         color: Colors.black,
                        //       )),
                        //   height: MediaQuery.of(context).size.height * 0.35,
                        //   width: MediaQuery.of(context).size.width,
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 5, right: 7, top: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: widget.image,
                          placeholder: ((context, url) =>
                              const Center(child: CircularProgressIndicator())),
                          errorWidget: ((context, url, error) => const Icon(
                                Icons.error,
                                color: Colors.black,
                              )),
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.imageName,
                      style: GoogleFonts.roboto(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    RatingBar.builder(
                      itemSize: 20,
                      initialRating:
                          double.tryParse('${widget.postratng}')!.toDouble(),
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ignoreGestures: true,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  widget.imagedes,
                  style: GoogleFonts.roboto(
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.w300,
                  ),
                  maxLines: 3,
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade400,
              ),
              Expanded(
                // height: Get.height,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.postId['postId'])
                        .collection('comments')
                        .orderBy('datePublished', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> comments =
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;
                              // final date = DateTime.fromMillisecondsSinceEpoch(
                              //     comments['datePublished']);

                              return Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              child: CachedNetworkImage(
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(),
                                                imageUrl:
                                                    '${comments['profilePic']}',
                                              ),
                                            ),
                                          ),

                                          // CircleAvatar(
                                          //   radius: 25,
                                          //   backgroundImage:
                                          // ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${comments['name']}',
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  getmin(
                                                    startDate: comments[
                                                            'datePublished']
                                                        .toDate(),
                                                  ),
                                                  // (comments['datePublished']
                                                  //         as Timestamp)
                                                  //     .toDate()
                                                  //     .toString(),
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 11,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Container(
                                                  width: width * 0.7,
                                                  child: Text(
                                                    '${comments['text']}',
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 14,
                                                        color: Colors.black
                                                            .withOpacity(0.9),
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                comments['rating'] == 0
                                                    ? Container()
                                                    : RatingBar.builder(
                                                        itemSize: 18,
                                                        initialRating: comments[
                                                                        'rating'] ==
                                                                    "" ||
                                                                comments[
                                                                        'rating'] ==
                                                                    null
                                                            ? 0
                                                            : comments[
                                                                'rating'],
                                                        minRating: 0,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        ignoreGestures: true,
                                                        itemPadding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    2.0),
                                                        itemBuilder: (context,
                                                                _) =>
                                                            const Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                        onRatingUpdate:
                                                            (rating) {
                                                          // setState(() {
                                                          //   ratingStar = rating;
                                                          // });
                                                          // RatingBar.builder(
                                                          //   itemSize: 20,
                                                          //   initialRating: 0,
                                                          //   minRating: 0,
                                                          //   direction: Axis.horizontal,
                                                          //   allowHalfRating: true,
                                                          //   itemCount: 5,
                                                          //   itemPadding:
                                                          //       const EdgeInsets.symmetric(
                                                          //           horizontal: 2.0),
                                                          //   itemBuilder: (context, _) =>
                                                          //       const Icon(
                                                          //     Icons.star,
                                                          //     color: Colors.amber,
                                                          //   ),
                                                          //   onRatingUpdate: (rating) {
                                                          //     setState(() {
                                                          //       ratingStar = rating;
                                                          //     });
                                                          //   },
                                                          // ),
                                                        })
                                              ]),

                                          // Icon(
                                          //   Icons.add,

                                          // ),
                                          Container(
                                            width: 30,
                                            child: IconButton(
                                              onPressed: () {
                                                showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    context: context,
                                                    builder: (context) {
                                                      return Container(
                                                        margin:
                                                            EdgeInsets.all(9),
                                                        // height: height * 0.2,
                                                        padding: EdgeInsets.only(
                                                            top: 10,
                                                            left: 20,
                                                            right: 20,
                                                            bottom:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),

                                                        color: Colors.white,
                                                        child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              height * 0.1,
                                                                          width:
                                                                              width * 0.7,
                                                                          child:
                                                                              TextField(
                                                                            decoration: InputDecoration(
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(20),
                                                                                ),
                                                                                labelText: "Edit"),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(bottom: 20),
                                                                          child:
                                                                              Icon(Icons.send),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ]),
                                                            ]),
                                                      );
                                                    });
                                              },

                                              // onPressed: () {
                                              //   FirebaseFirestore.instance
                                              //       .collection('comments')
                                              //       .doc(snapshot
                                              //           .data!.docs[index].id)
                                              //      .update()
                                              //       .then((value) =>
                                              //           Navigator.pop(context));
                                              // },
                                              icon: Icon(
                                                Icons.edit_outlined,
                                                size: 25,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              );
                            });
                      } else {
                        return Container();
                      }
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    child: Form(
                      key: _commentformkey,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 9,
                        ),
                        width: MediaQuery.of(context).size.width * 0.79,
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 4,
                          // validator: ((val) => commentController.text.isEmpty
                          //     ? "Please Enter Comment"
                          //     : null),
                          // onChanged: (value) {
                          //   setState(() {
                          //     value = commentController.text;
                          //   });
                          // },
                          onTap: () {
                            setState(() {
                              emojiShowing != emojiShowing;
                              showCommentstar = true;

                              if (keyboardheight == true) {
                                setState(() {
                                  emojiShowing = false;
                                });
                              }
                            });
                          },

                          controller: commentController,

                          decoration: InputDecoration(
                            // suffixIcon: Container(
                            //   width: width * 0.4,
                            //   alignment: Alignment.centerRight,
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(right: 5),
                            //     child: RatingBar.builder(
                            //       itemSize: 19,
                            //       initialRating: ratingStar,
                            //       minRating: 0,
                            //       direction: Axis.horizontal,
                            //       allowHalfRating: true,
                            //       itemCount: 5,
                            //       itemPadding: const EdgeInsets.symmetric(
                            //           horizontal: 2.0),
                            //       itemBuilder: (context, _) => const Icon(
                            //         Icons.star,
                            //         color: Colors.red,
                            //       ),
                            //       onRatingUpdate: (rating) {
                            //         setState(() {
                            //           ratingStar = rating;
                            //           // ratingStar = rating;
                            //           // starReset == true ? rating = 0 : rating;
                            //         });
                            //       },
                            //     ),
                            //   ),
                            // ),
                            prefixIcon: IconButton(
                              onPressed: () {
                                if (emojiShowing == false) {
                                  FocusScope.of(context).unfocus();
                                }
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  emojiShowing = !emojiShowing;

                                  keyboardheight = true;
                                });
                              },
                              icon: Icon(Icons.emoji_emotions),
                            ),

                            hintText: 'Comment',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),

                        // child: CustomTextField(
                        //     textFieldontap: () {
                        //       setState(() {
                        //         emojiShowing != emojiShowing;

                        //         if (keyboardheight == true) {
                        //           setState(() {
                        //             emojiShowing = false;
                        //           });
                        //         }
                        //       });
                        //     },
                        //     controller: commentController,
                        //     hintText: 'Comment',
                        //     isIcon: true,
                        //     icon: Icons.emoji_emotions,

                        //     ontap: () {
                        //       if (emojiShowing == false) {
                        //         FocusScope.of(context).unfocus();
                        //       }
                        //       FocusScope.of(context).unfocus();
                        //       setState(() {
                        //         emojiShowing = !emojiShowing;

                        //         keyboardheight = true;
                        //       });
                        //     },
                        //     maxLines: 1),
                      ),
                    ),
                  ),
                  Container(
                    // alignment: Alignment.topCenter,
                    height: height * 0.1,
                    width: width * 0.1,

                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Users")
                            .where('uid',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                // shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> userDetail =
                                      snapshot.data!.docs[index].data()
                                          as Map<String, dynamic>;
                                  return GestureDetector(
                                    onTap: () {
                                      if (_commentformkey.currentState!
                                              .validate() ||
                                          ratingStar > 0) {
                                        setState(() {
                                          showCommentstar = false;
                                          emojiShowing = false;
                                        });
                                        postComment(
                                            userDetail['uid'],
                                            userDetail['name'],
                                            userDetail['photo'],
                                            commentController);
                                        FocusScope.of(context).unfocus();
                                      }

                                      // postComment(
                                      //   userDetail['uid'],
                                      //   userDetail['name'],
                                      //   userDetail['photo'],
                                      // );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 18),
                                      child: Icon(
                                        Icons.send,
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                });
                          }
                        }),
                  ),
                ],
              ),
              Offstage(
                offstage: !emojiShowing,
                child: SizedBox(
                    height: height,
                    width: double.infinity,
                    child: EmojiPicker(
                      textEditingController: commentController,
                      config: Config(
                        columns: 7,
                        // Issue: https://github.com/flutter/flutter/issues/28894
                        emojiSizeMax: 32 *
                            (foundation.defaultTargetPlatform ==
                                    TargetPlatform.iOS
                                ? 1.30
                                : 1.0),
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        gridPadding: EdgeInsets.zero,
                        initCategory: Category.RECENT,
                        bgColor: const Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        showRecentsTab: true,
                        recentsLimit: 28,
                        replaceEmojiOnLimitExceed: false,
                        noRecents: const Text(
                          'No Recents',
                          style: TextStyle(fontSize: 20, color: Colors.black26),
                          textAlign: TextAlign.center,
                        ),
                        loadingIndicator: const SizedBox.shrink(),
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL,
                        checkPlatformCompatibility: true,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // String getmin(DateTime datePublished) {
  //   final now = DateTime.now();
  //   final dur = now.difference(datePublished);
  //   if (datePublished) {

  //   } else {

  //   }
  //   return dur.inMinutes.toString() + ' minutes ago';
  // }
  String getmin({required DateTime startDate}) {
    final now = DateTime.now();
    final dur = now.difference(startDate);

    if (dur.inSeconds < 60)
      return '${dur.inSeconds} seconds ago';
    else if (dur.inMinutes < 60)
      return '${dur.inMinutes} minutes ago';
    else if (dur.inHours < 24)
      return '${dur.inHours} hours ago';
    else if (dur.inDays < 30)
      return '${dur.inDays} days ago';
    else
      return '${(dur.inDays / 30).toInt()} months ago';
  }
}
