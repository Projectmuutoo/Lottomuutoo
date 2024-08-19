////////////////////////////////////////////////////LOGIN////////////////////////////////////////////////
// To parse this JSON data, do
//
//     final userLoginPost = userLoginPostFromJson(jsonString);

import 'dart:convert';

UserLoginPost userLoginPostFromJson(String str) =>
    UserLoginPost.fromJson(json.decode(str));

String userLoginPostToJson(UserLoginPost data) => json.encode(data.toJson());

class UserLoginPost {
  String email;
  String password;

  UserLoginPost({
    required this.email,
    required this.password,
  });

  factory UserLoginPost.fromJson(Map<String, dynamic> json) => UserLoginPost(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
