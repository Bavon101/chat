// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.userId,
    this.userName,
    this.userEmail,
    this.userProfilePhoto,
    this.created,
  });

  String? userId;
  String? userName;
  String? userEmail;
  String? userProfilePhoto;
  String? created;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json["user_id"],
        userName: json["user_name"],
        userEmail: json["user_email"],
        userProfilePhoto: json["user_profile_photo"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "user_email": userEmail,
        "user_profile_photo": userProfilePhoto,
        "created": created,
      };
}
