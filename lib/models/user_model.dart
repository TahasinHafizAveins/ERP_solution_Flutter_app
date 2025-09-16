import 'package:erp_solution/models/user_result.dart';

class UserModel {
  UserResult? result;
  String? message;
  String? responseCode;
  int? statusCode;

  UserModel({this.result, this.message, this.responseCode, this.statusCode});

  UserModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'] != null
        ? UserResult.fromJson(json['Result'])
        : null;
    message = json['Message'];
    responseCode = json['ResponseCode'];
    statusCode = json['StatusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['Result'] = result!.toJson();
    }
    data['Message'] = message;
    data['ResponseCode'] = responseCode;
    data['StatusCode'] = statusCode;
    return data;
  }
}
