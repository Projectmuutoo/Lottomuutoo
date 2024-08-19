// To parse this JSON data, do
//
//     final userRegisterPost = userRegisterPostFromJson(jsonString);

import 'dart:convert';

UserRegisterPost userRegisterPostFromJson(String str) =>
    UserRegisterPost.fromJson(json.decode(str));

String userRegisterPostToJson(UserRegisterPost data) =>
    json.encode(data.toJson());

class UserRegisterPost {
  String name;
  String email;
  String password;
  int money;

  UserRegisterPost({
    required this.name,
    required this.email,
    required this.password,
    required this.money,
  });

  factory UserRegisterPost.fromJson(Map<String, dynamic> json) =>
      UserRegisterPost(
        name: json["name"],
        email: json["email"],
        password: json["password"],
        money: json["money"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "money": money,
      };
}
