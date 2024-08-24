/////////////////////////////////////////////////USER GET RESPONSE///////////////////////////////////////////////////
// To parse this JSON data, do
//
//     final userGetResponse = userGetResponseFromJson(jsonString);

import 'dart:convert';

UserGetResponse userGetResponseFromJson(String str) =>
    UserGetResponse.fromJson(json.decode(str));

String userGetResponseToJson(UserGetResponse data) =>
    json.encode(data.toJson());

class UserGetResponse {
  List<UserGetResponseResult> result;
  bool response;

  UserGetResponse({
    required this.result,
    required this.response,
  });

  factory UserGetResponse.fromJson(Map<String, dynamic> json) =>
      UserGetResponse(
        result: List<UserGetResponseResult>.from(
            json["result"].map((x) => UserGetResponseResult.fromJson(x))),
        response: json["response"],
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "response": response,
      };

  map(Function(dynamic result) param0) {}
}

class UserGetResponseResult {
  int uid;
  String name;
  String email;
  String password;
  int money;

  UserGetResponseResult({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    required this.money,
  });

  factory UserGetResponseResult.fromJson(Map<String, dynamic> json) =>
      UserGetResponseResult(
        uid: json["uid"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        money: json["money"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email": email,
        "password": password,
        "money": money,
      };
}
