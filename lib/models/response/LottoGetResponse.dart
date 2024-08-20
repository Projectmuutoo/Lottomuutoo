// To parse this JSON data, do
//
//     final lottoPostReq = lottoPostReqFromJson(jsonString);

import 'dart:convert';

LottoPostReq lottoPostReqFromJson(String str) =>
    LottoPostReq.fromJson(json.decode(str));

String lottoPostReqToJson(LottoPostReq data) => json.encode(data.toJson());

class LottoPostReq {
  bool response;
  List<LottoPostReqResult> result;

  LottoPostReq({
    required this.response,
    required this.result,
  });

  factory LottoPostReq.fromJson(Map<String, dynamic> json) => LottoPostReq(
        response: json["response"],
        result: List<LottoPostReqResult>.from(
            json["result"].map((x) => LottoPostReqResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class LottoPostReqResult {
  int lid;
  String number;
  int? owner;
  int sell;
  int win;

  LottoPostReqResult({
    required this.lid,
    required this.number,
    required this.owner,
    required this.sell,
    required this.win,
  });

  factory LottoPostReqResult.fromJson(Map<String, dynamic> json) =>
      LottoPostReqResult(
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
