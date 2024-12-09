class UserModel {
  String? name;
  String? email;
  String? uid;
  String? photo;

  UserModel({
    this.email,
    this.name,
    this.photo,
    this.uid,
  });

  factory UserModel.fromMap(map) {
    return UserModel(
      email: map['email'],
      name: map['name'],
      photo: map['photo'],
      uid: map['uid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'photo': photo,
      'uid': uid,
    };
  }
}
