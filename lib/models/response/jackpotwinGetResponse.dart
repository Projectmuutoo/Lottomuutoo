// To parse this JSON data, do
//
//     final jackpotwinGetResponse = jackpotwinGetResponseFromJson(jsonString);

import 'dart:convert';

JackpotwinGetResponse jackpotwinGetResponseFromJson(String str) =>
    JackpotwinGetResponse.fromJson(json.decode(str));

String jackpotwinGetResponseToJson(JackpotwinGetResponse data) =>
    json.encode(data.toJson());

class JackpotwinGetResponse {
  bool response;
  List<Result> result;

  JackpotwinGetResponse({
    required this.response,
    required this.result,
  });

  factory JackpotwinGetResponse.fromJson(Map<String, dynamic> json) =>
      JackpotwinGetResponse(
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
  int lid;
  String number;
  dynamic owner;
  int sell;
  int win;

  Result({
    required this.lid,
    required this.number,
    required this.owner,
    required this.sell,
    required this.win,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        lid: json["lid"],
        number: json["number"],
        owner: json["owner"],
        sell: json["sell"],
        win: json["win"],
      );

  Map<String, dynamic> toJson() => {
        "lid": lid,
        "number": number,
        "owner": owner,
        "sell": sell,
        "win": win,
      };
}
