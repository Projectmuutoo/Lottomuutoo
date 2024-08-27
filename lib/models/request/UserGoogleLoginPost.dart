// To parse this JSON data, do
//
//     final loginGoogleReq = loginGoogleReqFromJson(jsonString);

import 'dart:convert';

LoginGoogleReq loginGoogleReqFromJson(String str) =>
    LoginGoogleReq.fromJson(json.decode(str));

String loginGoogleReqToJson(LoginGoogleReq data) => json.encode(data.toJson());

class LoginGoogleReq {
  String email;
  int money;

  LoginGoogleReq({
    required this.email,
    required this.money,
  });

  factory LoginGoogleReq.fromJson(Map<String, dynamic> json) => LoginGoogleReq(
        email: json["email"],
        money: json["money"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "money": money,
      };
}
