// To parse this JSON data, do
//
//     final addToCartPostRequest = addToCartPostRequestFromJson(jsonString);

import 'dart:convert';

AddToCartPostRequest addToCartPostRequestFromJson(String str) =>
    AddToCartPostRequest.fromJson(json.decode(str));

String addToCartPostRequestToJson(AddToCartPostRequest data) =>
    json.encode(data.toJson());

class AddToCartPostRequest {
  int bUid;
  int bLid;

  AddToCartPostRequest({
    required this.bUid,
    required this.bLid,
  });

  factory AddToCartPostRequest.fromJson(Map<String, dynamic> json) =>
      AddToCartPostRequest(
        bUid: json["b_uid"],
        bLid: json["b_lid"],
      );

  Map<String, dynamic> toJson() => {
        "b_uid": bUid,
        "b_lid": bLid,
      };
}
