// To parse this JSON data, do
//
//     final userGetBasketResponse = userGetBasketResponseFromJson(jsonString);

import 'dart:convert';

UserGetBasketResponse userGetBasketResponseFromJson(String str) =>
    UserGetBasketResponse.fromJson(json.decode(str));

String userGetBasketResponseToJson(UserGetBasketResponse data) =>
    json.encode(data.toJson());

class UserGetBasketResponse {
  bool response;
  List<Result> result;

  UserGetBasketResponse({
    required this.response,
    required this.result,
  });

  factory UserGetBasketResponse.fromJson(Map<String, dynamic> json) =>
      UserGetBasketResponse(
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
  int lid;
  String number;
  dynamic owner;
  int sell;
  int win;

  Result({
    required this.bid,
    required this.bUid,
    required this.bLid,
    required this.date,
    required this.lid,
    required this.number,
    required this.owner,
    required this.sell,
    required this.win,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        bid: json["bid"],
        bUid: json["b_uid"],
        bLid: json["b_lid"],
        date: json["date"],
        lid: json["lid"],
        number: json["number"],
        owner: json["owner"],
        sell: json["sell"],
        win: json["win"],
      );

  Map<String, dynamic> toJson() => {
        "bid": bid,
        "b_uid": bUid,
        "b_lid": bLid,
        "date": date,
        "lid": lid,
        "number": number,
        "owner": owner,
        "sell": sell,
        "win": win,
      };
}
