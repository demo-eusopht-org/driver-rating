import 'package:cloud_firestore/cloud_firestore.dart';

class CreatePostModel {
  String? postTitle;
  String? postdes;
  String? userPhoto;
  String? userName;
  String? postId;
  String? post;
  String? uid;

  Timestamp? createdAt;

  double? rating;
  final int? commentLen;
  CreatePostModel(
      {this.post,
      this.createdAt,
      this.postTitle,
      this.postdes,
      this.rating,
      this.commentLen,
      this.postId,
      this.userName,
      this.userPhoto,
      this.uid});

  factory CreatePostModel.fromMap(map) {
    return CreatePostModel(
      uid: map["uid"],
      post: map['post'],
      postdes: map['postdes'],
      rating: map['rating'],
      postTitle: map['postTitle'],
      commentLen: map['commentLen'],
      userName: map['userName'],
      userPhoto: map['userPhoto'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      'post': post,
      'postTitle': postTitle,
      'rating': rating,
      'postdes': postdes,
      'commentLen': commentLen,
      'postId': postId,
      'userPhoto': userPhoto,
      'userName': userName,
      'createdAt': createdAt,
    };
  }
}
