import 'package:erp_solution/models/attendance_summery_result_model.dart';

class AttendanceSummeryModel {
  List<Result>? result;
  int? id;
  String? exception;
  int? status;
  bool? isCanceled;
  bool? isCompleted;
  bool? isCompletedSuccessfully;
  int? creationOptions;
  String? asyncState;
  bool? isFaulted;

  AttendanceSummeryModel({
    this.result,
    this.id,
    this.exception,
    this.status,
    this.isCanceled,
    this.isCompleted,
    this.isCompletedSuccessfully,
    this.creationOptions,
    this.asyncState,
    this.isFaulted,
  });

  AttendanceSummeryModel.fromJson(Map<String, dynamic> json) {
    if (json['Result'] != null) {
      result = <Result>[];
      json['Result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
    id = json['Id'];
    exception = json['Exception'];
    status = json['Status'];
    isCanceled = json['IsCanceled'];
    isCompleted = json['IsCompleted'];
    isCompletedSuccessfully = json['IsCompletedSuccessfully'];
    creationOptions = json['CreationOptions'];
    asyncState = json['AsyncState'];
    isFaulted = json['IsFaulted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    /*if (result != null) {
      data['Result'] = result!.map((v) => v.toJson()).toList();
    }*/
    data['Id'] = id;
    data['Exception'] = exception;
    data['Status'] = status;
    data['IsCanceled'] = isCanceled;
    data['IsCompleted'] = isCompleted;
    data['IsCompletedSuccessfully'] = isCompletedSuccessfully;
    data['CreationOptions'] = creationOptions;
    data['AsyncState'] = asyncState;
    data['IsFaulted'] = isFaulted;
    return data;
  }
}
