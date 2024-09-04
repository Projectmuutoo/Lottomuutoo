// To parse this JSON data, do
//
//     final resetpasswordPutRequest = resetpasswordPutRequestFromJson(jsonString);

import 'dart:convert';

ResetpasswordPutRequest resetpasswordPutRequestFromJson(String str) =>
    ResetpasswordPutRequest.fromJson(json.decode(str));

String resetpasswordPutRequestToJson(ResetpasswordPutRequest data) =>
    json.encode(data.toJson());

class ResetpasswordPutRequest {
  String email;
  String password;

  ResetpasswordPutRequest({
    required this.email,
    required this.password,
  });

  factory ResetpasswordPutRequest.fromJson(Map<String, dynamic> json) =>
      ResetpasswordPutRequest(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
