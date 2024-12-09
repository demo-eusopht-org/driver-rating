import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../Model/post_model.dart';

class DriverRatingDatabase {
  User? user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  uploadPost({
    required String title,
    required String des,
    required String post,
    required String userName,
    required String userImage,
    double? rating,
    required Timestamp createdAt,
    required BuildContext context,
  }) async {
    try {
      String postId = Uuid().v1();
      CreatePostModel createPost = CreatePostModel(
        post: post,
        postTitle: title,
        postdes: des,
        createdAt: createdAt,
        rating: rating!.toDouble(),
        userName: userName,
        userPhoto: userImage,
        postId: postId,
        uid: user!.uid,
      );
      await db.collection('posts').doc(postId).set(createPost.toMap());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e'),
        ),
      );
    }
  }

  Future<String> postComment(BuildContext context, String postId, String text,
      String uid, String name, String profilePic, double rating) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty || rating > 0) {
        // if the likes list contains the user uid, we need to remove it
        // final commentId =

        //     db.collection('posts').doc(postId).collection('Comments').doc().id;
        String commentId = Uuid().v1();
        db
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'commendUid': commentId,
          'rating': rating,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
