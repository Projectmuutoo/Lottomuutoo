// To parse this JSON data, do
//
//     final updateMoneyResponse = updateMoneyResponseFromJson(jsonString);

import 'dart:convert';

UpdateMoneyResponse updateMoneyResponseFromJson(String str) =>
    UpdateMoneyResponse.fromJson(json.decode(str));

String updateMoneyResponseToJson(UpdateMoneyResponse data) =>
    json.encode(data.toJson());

class UpdateMoneyResponse {
  int money;

  UpdateMoneyResponse({
    required this.money,
  });

  factory UpdateMoneyResponse.fromJson(Map<String, dynamic> json) =>
      UpdateMoneyResponse(
        money: json["money"],
      );

  Map<String, dynamic> toJson() => {
        "money": money,
      };
}
