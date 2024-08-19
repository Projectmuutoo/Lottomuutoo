// To parse this JSON data, do
//
//     final userRegisterPostResponse = userRegisterPostResponseFromJson(jsonString);

import 'dart:convert';

UserRegisterPostResponse userRegisterPostResponseFromJson(String str) =>
    UserRegisterPostResponse.fromJson(json.decode(str));

String userRegisterPostResponseToJson(UserRegisterPostResponse data) =>
    json.encode(data.toJson());

class UserRegisterPostResponse {
  bool response;
  String message;

  UserRegisterPostResponse({
    required this.response,
    required this.message,
  });

  factory UserRegisterPostResponse.fromJson(Map<String, dynamic> json) =>
      UserRegisterPostResponse(
        response: json["response"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "message": message,
      };
}
