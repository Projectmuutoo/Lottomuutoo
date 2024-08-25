// To parse this JSON data, do
//
//     final userGetBasketEmailResponse = userGetBasketEmailResponseFromJson(jsonString);

import 'dart:convert';

UserGetBasketEmailResponse userGetBasketEmailResponseFromJson(String str) =>
    UserGetBasketEmailResponse.fromJson(json.decode(str));

String userGetBasketEmailResponseToJson(UserGetBasketEmailResponse data) =>
    json.encode(data.toJson());

class UserGetBasketEmailResponse {
  bool response;
  List<Result> result;

  UserGetBasketEmailResponse({
    required this.response,
    required this.result,
  });

  factory UserGetBasketEmailResponse.fromJson(Map<String, dynamic> json) =>
      UserGetBasketEmailResponse(
        response: json["response"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class Result {
  int bid;
  int bUid;
  int bLid;
  String date;

  Result({
    required this.bid,
    required this.bUid,
    required this.bLid,
    required this.date,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        bid: json["bid"],
        bUid: json["b_uid"],
        bLid: json["b_lid"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "bid": bid,
        "b_uid": bUid,
        "b_lid": bLid,
        "date": date,
      };
}
