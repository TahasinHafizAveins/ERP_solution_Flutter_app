class PendingLeaveApplication {
  final String autoGenRowNum;
  final int employeeLeaveAID;
  final int leaveCategoryID;
  final String leaveCategory;
  final String employeeName;
  final String employeeCode;
  final String leaveDates;
  final double numberOfLeave;
  final String approvalStatus;
  final int approvalStatusID;
  final int approvalProcessID;
  final int apEmployeeFeedbackID;
  final int apForwardInfoID;
  final String createdDate;
  final String leaveType;
  final bool isLFAApplied;
  final bool isCurrentAPEmployee;
  final bool isReassessment;
  final bool isReturned;
  final int totalEmployementDays;

  PendingLeaveApplication({
    required this.autoGenRowNum,
    required this.employeeLeaveAID,
    required this.leaveCategoryID,
    required this.leaveCategory,
    required this.employeeName,
    required this.employeeCode,
    required this.leaveDates,
    required this.numberOfLeave,
    required this.approvalStatus,
    required this.approvalStatusID,
    required this.approvalProcessID,
    required this.apEmployeeFeedbackID,
    required this.apForwardInfoID,
    required this.createdDate,
    required this.leaveType,
    required this.isLFAApplied,
    required this.isCurrentAPEmployee,
    required this.isReassessment,
    required this.isReturned,
    required this.totalEmployementDays,
  });

  factory PendingLeaveApplication.fromJson(Map<String, dynamic> json) {
    return PendingLeaveApplication(
      autoGenRowNum: json['AutoGenRowNum']?.toString() ?? '',
      employeeLeaveAID: json['EmployeeLeaveAID'] as int? ?? 0,
      leaveCategoryID: json['LeaveCategoryID'] as int? ?? 0,
      leaveCategory: json['LeaveCategory']?.toString() ?? '',
      employeeName: json['EmployeeName']?.toString() ?? '',
      employeeCode: json['EmployeeCode']?.toString() ?? '',
      leaveDates: json['LeaveDates']?.toString() ?? '',
      numberOfLeave: (json['NumberOfLeave'] as num).toDouble(),
      approvalStatus: json['ApprovalStatus']?.toString() ?? '',
      approvalStatusID: json['ApprovalStatusID'] as int? ?? 0,
      approvalProcessID: json['ApprovalProcessID'] as int? ?? 0,
      apEmployeeFeedbackID: json['APEmployeeFeedbackID'] as int? ?? 0,
      apForwardInfoID: json['APForwardInfoID'] as int? ?? 0,
      createdDate: json['CreatedDate']?.toString() ?? '',
      leaveType: json['LeaveType']?.toString() ?? '',
      isLFAApplied: json['IsLFAApplied'] as bool? ?? false,
      isCurrentAPEmployee: json['IsCurrentAPEmployee'] as bool? ?? false,
      isReassessment: json['IsReassessment'] as bool? ?? false,
      isReturned: json['IsReturned'] as bool? ?? false,
      totalEmployementDays: json['TotalEmployementDays'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AutoGenRowNum': autoGenRowNum,
      'EmployeeLeaveAID': employeeLeaveAID,
      'LeaveCategoryID': leaveCategoryID,
      'LeaveCategory': leaveCategory,
      'EmployeeName': employeeName,
      'EmployeeCode': employeeCode,
      'LeaveDates': leaveDates,
      'NumberOfLeave': numberOfLeave,
      'ApprovalStatus': approvalStatus,
      'ApprovalStatusID': approvalStatusID,
      'ApprovalProcessID': approvalProcessID,
      'APEmployeeFeedbackID': apEmployeeFeedbackID,
      'APForwardInfoID': apForwardInfoID,
      'CreatedDate': createdDate,
      'LeaveType': leaveType,
      'IsLFAApplied': isLFAApplied,
      'IsCurrentAPEmployee': isCurrentAPEmployee,
      'IsReassessment': isReassessment,
      'IsReturned': isReturned,
      'TotalEmployementDays': totalEmployementDays,
    };
  }
}

class PendingLeaveApplicationResponse {
  final List<PendingLeaveApplication> rows;
  final int total;
  final bool isSubmittedFromPopup;

  PendingLeaveApplicationResponse({
    required this.rows,
    required this.total,
    required this.isSubmittedFromPopup,
  });

  factory PendingLeaveApplicationResponse.fromJson(Map<String, dynamic> json) {
    final rows = json['Rows'] as List? ?? [];
    return PendingLeaveApplicationResponse(
      rows: rows
          .map<PendingLeaveApplication>(
            (item) => PendingLeaveApplication.fromJson(item),
          )
          .toList(),
      total: json['Total'] as int? ?? 0,
      isSubmittedFromPopup: json['IsSubmittedFromPopup'] as bool? ?? false,
    );
  }
}
