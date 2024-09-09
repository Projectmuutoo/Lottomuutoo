// To parse this JSON data, do
//
//     final lottoNoItemGetResponse = lottoNoItemGetResponseFromJson(jsonString);

import 'dart:convert';

LottoNoItemGetResponse lottoNoItemGetResponseFromJson(String str) =>
    LottoNoItemGetResponse.fromJson(json.decode(str));

String lottoNoItemGetResponseToJson(LottoNoItemGetResponse data) =>
    json.encode(data.toJson());

class LottoNoItemGetResponse {
  bool response;

  LottoNoItemGetResponse({
    required this.response,
  });

  factory LottoNoItemGetResponse.fromJson(Map<String, dynamic> json) =>
      LottoNoItemGetResponse(
        response: json["response"],
      );

  Map<String, dynamic> toJson() => {
        "response": response,
      };
}
