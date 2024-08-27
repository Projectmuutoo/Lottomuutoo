// To parse this JSON data, do
//
//     final addToCartPostResponse = addToCartPostResponseFromJson(jsonString);

import 'dart:convert';

AddToCartPostResponse addToCartPostResponseFromJson(String str) =>
    AddToCartPostResponse.fromJson(json.decode(str));

String addToCartPostResponseToJson(AddToCartPostResponse data) =>
    json.encode(data.toJson());

class AddToCartPostResponse {
  bool response;
  String message;

  AddToCartPostResponse({
    required this.response,
    required this.message,
  });

  factory AddToCartPostResponse.fromJson(Map<String, dynamic> json) =>
      AddToCartPostResponse(
        response: json["response"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "message": message,
      };
}
