class LeaveApplicationListModel {
  String? autoGenRowNum;
  int? employeeLeaveAID;
  int? leaveCategoryID;
  String? leaveCategory;
  String? leaveDates;
  double? numberOfLeave;
  String? approvalStatus;
  int? approvalStatusID;
  int? approvalProcessID;
  int? apEmployeeFeedbackID;
  String? createdDate;
  String? leaveType;
  String? employeeCode;
  String? employeeName;
  bool? isLFAApplied;
  bool? isCurrentAPEmployee;
  bool? isReassessment;
  bool? isReturned;
  int? totalEmployementDays;

  LeaveApplicationListModel({
    this.autoGenRowNum,
    this.employeeLeaveAID,
    this.leaveCategoryID,
    this.leaveCategory,
    this.leaveDates,
    this.numberOfLeave,
    this.approvalStatus,
    this.approvalStatusID,
    this.approvalProcessID,
    this.apEmployeeFeedbackID,
    this.createdDate,
    this.leaveType,
    this.employeeCode,
    this.employeeName,
    this.isLFAApplied,
    this.isCurrentAPEmployee,
    this.isReassessment,
    this.isReturned,
    this.totalEmployementDays,
  });

  LeaveApplicationListModel.fromJson(Map<String, dynamic> json) {
    autoGenRowNum = json['AutoGenRowNum'];
    employeeLeaveAID = json['EmployeeLeaveAID'];
    leaveCategoryID = json['LeaveCategoryID'];
    leaveCategory = json['LeaveCategory'];
    leaveDates = json['LeaveDates'];
    numberOfLeave = json['NumberOfLeave'];
    approvalStatus = json['ApprovalStatus'];
    approvalStatusID = json['ApprovalStatusID'];
    approvalProcessID = json['ApprovalProcessID'];
    apEmployeeFeedbackID = json['APEmployeeFeedbackID'];
    createdDate = json['CreatedDate'];
    leaveType = json['LeaveType'];
    employeeCode = json['EmployeeCode'];
    employeeName = json['EmployeeName'];
    isLFAApplied = json['IsLFAApplied'];
    isCurrentAPEmployee = json['IsCurrentAPEmployee'];
    isReassessment = json['IsReassessment'];
    isReturned = json['IsReturned'];
    totalEmployementDays = json['TotalEmployementDays'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AutoGenRowNum'] = autoGenRowNum;
    data['EmployeeLeaveAID'] = employeeLeaveAID;
    data['LeaveCategoryID'] = leaveCategoryID;
    data['LeaveCategory'] = leaveCategory;
    data['LeaveDates'] = leaveDates;
    data['NumberOfLeave'] = numberOfLeave;
    data['ApprovalStatus'] = approvalStatus;
    data['ApprovalStatusID'] = approvalStatusID;
    data['ApprovalProcessID'] = approvalProcessID;
    data['APEmployeeFeedbackID'] = apEmployeeFeedbackID;
    data['CreatedDate'] = createdDate;
    data['LeaveType'] = leaveType;
    data['EmployeeCode'] = employeeCode;
    data['EmployeeName'] = employeeName;
    data['IsLFAApplied'] = isLFAApplied;
    data['IsCurrentAPEmployee'] = isCurrentAPEmployee;
    data['IsReassessment'] = isReassessment;
    data['IsReturned'] = isReturned;
    data['TotalEmployementDays'] = totalEmployementDays;
    return data;
  }
}
