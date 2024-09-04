// To parse this JSON data, do
//
//     final resetpasswordPutResponse = resetpasswordPutResponseFromJson(jsonString);

import 'dart:convert';

ResetpasswordPutResponse resetpasswordPutResponseFromJson(String str) =>
    ResetpasswordPutResponse.fromJson(json.decode(str));

String resetpasswordPutResponseToJson(ResetpasswordPutResponse data) =>
    json.encode(data.toJson());

class ResetpasswordPutResponse {
  bool response;
  String message;

  ResetpasswordPutResponse({
    required this.response,
    required this.message,
  });

  factory ResetpasswordPutResponse.fromJson(Map<String, dynamic> json) =>
      ResetpasswordPutResponse(
        response: json["response"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "message": message,
      };
}
