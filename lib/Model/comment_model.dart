import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String? username;
  String? comment;
  Timestamp? timestamp;
  String? userDp;
  String? userId;
  double? rating;
  CommentModel({
    this.username,
    this.comment,
    this.timestamp,
    this.userDp,
    this.userId,
    this.rating,
  });
  CommentModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    comment = json['comment'];
    timestamp = json['timestamp'];
    userDp = json['userDp'];
    userId = json['userId'];
    rating = json['rating'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['comment'] = this.comment;
    data['timestamp'] = this.timestamp;
    data['userDp'] = this.userDp;
    data['userId'] = this.userId;
    data['rating'] = this.rating;
    return data;
  }
}
