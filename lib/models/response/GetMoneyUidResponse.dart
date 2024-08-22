// To parse this JSON data, do
//
//     final getMoneyUid = getMoneyUidFromJson(jsonString);

import 'dart:convert';

List<GetMoneyUid> getMoneyUidFromJson(String str) => List<GetMoneyUid>.from(
    json.decode(str).map((x) => GetMoneyUid.fromJson(x)));

String getMoneyUidToJson(List<GetMoneyUid> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetMoneyUid {
  int mid;
  int mUid;
  int value;
  int type;
  String date;

  GetMoneyUid({
    required this.mid,
    required this.mUid,
    required this.value,
    required this.type,
    required this.date,
  });

  factory GetMoneyUid.fromJson(Map<String, dynamic> json) => GetMoneyUid(
        mid: json["mid"],
        mUid: json["m_uid"],
        value: json["value"],
        type: json["type"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "mid": mid,
        "m_uid": mUid,
        "value": value,
        "type": type,
        "date": date,
      };
}
