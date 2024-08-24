// To parse this JSON data, do
//
//     final lottoRewardGetResponse = lottoRewardGetResponseFromJson(jsonString);

import 'dart:convert';

LottoRewardGetResponse lottoRewardGetResponseFromJson(String str) =>
    LottoRewardGetResponse.fromJson(json.decode(str));

String lottoRewardGetResponseToJson(LottoRewardGetResponse data) =>
    json.encode(data.toJson());

class LottoRewardGetResponse {
  bool response;
  List<Result> result;

  LottoRewardGetResponse({
    required this.response,
    required this.result,
  });

  factory LottoRewardGetResponse.fromJson(Map<String, dynamic> json) =>
      LottoRewardGetResponse(
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
  int owner;
  int sell;
  int win;
  int reward;

  Result({
    required this.lid,
    required this.number,
    required this.owner,
    required this.sell,
    required this.win,
    required this.reward,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        lid: json["lid"],
        number: json["number"],
        owner: json["owner"],
        sell: json["sell"],
        win: json["win"],
        reward: json["reward"],
      );

  Map<String, dynamic> toJson() => {
        "lid": lid,
        "number": number,
        "owner": owner,
        "sell": sell,
        "win": win,
        "reward": reward,
      };
}
