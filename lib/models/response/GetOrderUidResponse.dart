// To parse this JSON data, do
//
//     final getOrderUid = getOrderUidFromJson(jsonString);

import 'dart:convert';

GetOrderUid getOrderUidFromJson(String str) =>
    GetOrderUid.fromJson(json.decode(str));

String getOrderUidToJson(GetOrderUid data) => json.encode(data.toJson());

class GetOrderUid {
  bool response;
  List<Result> result;

  GetOrderUid({
    required this.response,
    required this.result,
  });

  factory GetOrderUid.fromJson(Map<String, dynamic> json) => GetOrderUid(
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
  int listid;
  int listUid;
  int listLid;
  String date;
  int lid;
  String number;
  dynamic owner;
  int sell;
  int win;

  Result({
    required this.listid,
    required this.listUid,
    required this.listLid,
    required this.date,
    required this.lid,
    required this.number,
    required this.owner,
    required this.sell,
    required this.win,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        listid: json["listid"],
        listUid: json["list_uid"],
        listLid: json["list_lid"],
        date: json["date"],
        lid: json["lid"],
        number: json["number"],
        owner: json["owner"],
        sell: json["sell"],
        win: json["win"],
      );

  Map<String, dynamic> toJson() => {
        "listid": listid,
        "list_uid": listUid,
        "list_lid": listLid,
        "date": date,
        "lid": lid,
        "number": number,
        "owner": owner,
        "sell": sell,
        "win": win,
      };
}
