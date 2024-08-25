// To parse this JSON data, do
//
//     final userIdxGetResponse = userIdxGetResponseFromJson(jsonString);

import 'dart:convert';

UserIdxGetResponse userIdxGetResponseFromJson(String str) =>
    UserIdxGetResponse.fromJson(json.decode(str));

String userIdxGetResponseToJson(UserIdxGetResponse data) =>
    json.encode(data.toJson());

class UserIdxGetResponse {
  List<Result> result;
  bool response;

  UserIdxGetResponse({
    required this.result,
    required this.response,
  });

  factory UserIdxGetResponse.fromJson(Map<String, dynamic> json) =>
      UserIdxGetResponse(
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
        response: json["response"],
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "response": response,
      };
}

class Result {
  int uid;
  String name;
  String nickname;
  String email;
  String password;
  String birth;
  String gender;
  String phone;
  int money;

  Result({
    required this.uid,
    required this.name,
    required this.nickname,
    required this.email,
    required this.password,
    required this.birth,
    required this.gender,
    required this.phone,
    required this.money,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        uid: json["uid"],
        name: json["name"],
        nickname: json["nickname"],
        email: json["email"],
        password: json["password"],
        birth: json["birth"],
        gender: json["gender"],
        phone: json["phone"],
        money: json["money"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "nickname": nickname,
        "email": email,
        "password": password,
        "birth": birth,
        "gender": gender,
        "phone": phone,
        "money": money,
      };
}
