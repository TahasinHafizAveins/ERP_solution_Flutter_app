import 'package:erp_solution/models/leave_balances_model.dart';

class SelfLeaveApplicationDetailsModel {
  int? employeeID;
  String? fullName;
  String? employeeCode;
  String? departmentName;
  String? designationName;
  String? divisionName;
  String? imagePath;
  String? cancelledBy;
  String? remarks;
  List<LeaveBalances>? leaveBalances;
  List<Comments>? comments;
  List<RejectedMembers>? rejectedMembers;
  List<String>? forwardingMembers;
  List<Map<String, dynamic>>? attachments;
  bool? isCurrentAPEmployee;
  bool? isReassessment;
  int? aPForwardInfoID;
  int? cancellationStatus;
  String? lFADeclaration;
  int? employeeLeaveAID;
  String? requestStartDate;
  String? requestStartDateTime;
  String? requestEndDate;
  String? requestEndDateDateTime;
  String? leaveDates;
  double? numberOfLeave;
  String? backupEmployeeName;
  int? backupEmployeeID;
  int? leaveCategoryID;
  String? leaveCategory;
  String? purpose;
  String? leaveLocation;
  String? dateOfJoiningWork;
  List<LeaveDetails>? leaveDetails;
  int? approvalProcessID;
  bool? isLFA;
  bool? isFestival;
  String? formType;
  String? employeeWithCode;

  SelfLeaveApplicationDetailsModel({
    this.employeeID,
    this.fullName,
    this.employeeCode,
    this.departmentName,
    this.designationName,
    this.divisionName,
    this.imagePath,
    this.cancelledBy,
    this.remarks,
    this.leaveBalances,
    this.comments,
    this.rejectedMembers,
    this.forwardingMembers,
    this.attachments,
    this.isCurrentAPEmployee,
    this.isReassessment,
    this.aPForwardInfoID,
    this.cancellationStatus,
    this.lFADeclaration,
    this.employeeLeaveAID,
    this.requestStartDate,
    this.requestStartDateTime,
    this.requestEndDate,
    this.requestEndDateDateTime,
    this.leaveDates,
    this.numberOfLeave,
    this.backupEmployeeName,
    this.backupEmployeeID,
    this.leaveCategoryID,
    this.leaveCategory,
    this.purpose,
    this.leaveLocation,
    this.dateOfJoiningWork,
    this.leaveDetails,
    this.approvalProcessID,
    this.isLFA,
    this.isFestival,
    this.formType,
    this.employeeWithCode,
  });

  SelfLeaveApplicationDetailsModel.fromJson(Map<String, dynamic> json) {
    employeeID = json['EmployeeID'];
    fullName = json['FullName'];
    employeeCode = json['EmployeeCode'];
    departmentName = json['DepartmentName'];
    designationName = json['DesignationName'];
    divisionName = json['DivisionName'];
    imagePath = json['ImagePath'];
    cancelledBy = json['CancelledBy'];
    remarks = json['Remarks'];
    if (json['LeaveBalances'] != null) {
      leaveBalances = <LeaveBalances>[];
      json['LeaveBalances'].forEach((v) {
        leaveBalances!.add(LeaveBalances.fromJson(v));
      });
    }
    if (json['Comments'] != null) {
      comments = <Comments>[];
      json['Comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    }
    if (json['RejectedMembers'] != null) {
      rejectedMembers = <RejectedMembers>[];
      json['RejectedMembers'].forEach((v) {
        rejectedMembers!.add(RejectedMembers.fromJson(v));
      });
    }
    forwardingMembers = json['ForwardingMembers']?.cast<String>();
    attachments = (json['Attachments'] as List<dynamic>?)
        ?.map((item) => item as Map<String, dynamic>)
        .toList();
    isCurrentAPEmployee = json['IsCurrentAPEmployee'];
    isReassessment = json['IsReassessment'];
    aPForwardInfoID = json['APForwardInfoID'];
    cancellationStatus = json['CancellationStatus'];
    lFADeclaration = json['LFADeclaration'];
    employeeLeaveAID = json['EmployeeLeaveAID'];
    requestStartDate = json['RequestStartDate'];
    requestStartDateTime = json['RequestStartDateTime'];
    requestEndDate = json['RequestEndDate'];
    requestEndDateDateTime = json['RequestEndDateDateTime'];
    leaveDates = json['LeaveDates'];
    numberOfLeave = json['NumberOfLeave']?.toDouble(); // Convert to double
    backupEmployeeName = json['BackupEmployeeName'];
    backupEmployeeID = json['BackupEmployeeID'];
    leaveCategoryID = json['LeaveCategoryID'];
    leaveCategory = json['LeaveCategory'];
    purpose = json['Purpose'];
    leaveLocation = json['LeaveLocation'];
    dateOfJoiningWork = json['DateOfJoiningWork'];
    if (json['LeaveDetails'] != null) {
      leaveDetails = <LeaveDetails>[];
      json['LeaveDetails'].forEach((v) {
        leaveDetails!.add(LeaveDetails.fromJson(v));
      });
    }
    approvalProcessID = json['ApprovalProcessID'];
    isLFA = json['IsLFA'];
    isFestival = json['IsFestival'];
    formType = json['FormType'];
    employeeWithCode = json['EmployeeWithCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['EmployeeID'] = employeeID;
    data['FullName'] = fullName;
    data['EmployeeCode'] = employeeCode;
    data['DepartmentName'] = departmentName;
    data['DesignationName'] = designationName;
    data['DivisionName'] = divisionName;
    data['ImagePath'] = imagePath;
    data['CancelledBy'] = cancelledBy;
    data['Remarks'] = remarks;
    if (leaveBalances != null) {
      data['LeaveBalances'] = leaveBalances!.map((v) => v.toJson()).toList();
    }
    if (comments != null) {
      data['Comments'] = comments!.map((v) => v.toJson()).toList();
    }
    if (rejectedMembers != null) {
      data['RejectedMembers'] = rejectedMembers!
          .map((v) => v.toJson())
          .toList();
    }
    data['ForwardingMembers'] = forwardingMembers;
    data['Attachments'] = attachments;
    data['IsCurrentAPEmployee'] = isCurrentAPEmployee;
    data['IsReassessment'] = isReassessment;
    data['APForwardInfoID'] = aPForwardInfoID;
    data['CancellationStatus'] = cancellationStatus;
    data['LFADeclaration'] = lFADeclaration;
    data['EmployeeLeaveAID'] = employeeLeaveAID;
    data['RequestStartDate'] = requestStartDate;
    data['RequestStartDateTime'] = requestStartDateTime;
    data['RequestEndDate'] = requestEndDate;
    data['RequestEndDateDateTime'] = requestEndDateDateTime;
    data['LeaveDates'] = leaveDates;
    data['NumberOfLeave'] = numberOfLeave;
    data['BackupEmployeeName'] = backupEmployeeName;
    data['BackupEmployeeID'] = backupEmployeeID;
    data['LeaveCategoryID'] = leaveCategoryID;
    data['LeaveCategory'] = leaveCategory;
    data['Purpose'] = purpose;
    data['LeaveLocation'] = leaveLocation;
    data['DateOfJoiningWork'] = dateOfJoiningWork;
    if (leaveDetails != null) {
      data['LeaveDetails'] = leaveDetails!.map((v) => v.toJson()).toList();
    }
    data['ApprovalProcessID'] = approvalProcessID;
    data['IsLFA'] = isLFA;
    data['IsFestival'] = isFestival;
    data['FormType'] = formType;
    data['EmployeeWithCode'] = employeeWithCode;
    return data;
  }
}

class Comments {
  int? aPFeedbackID;
  String? comment;
  String? commentDateTime;
  int? employeeID;
  int? approvalProcessID;
  int? isProxyEmployeeRemarks;
  String? proxyEmployeeRemarks;
  String? orderCommentDateTime;
  String? fullName;
  String? imagePath;
  String? employeeCode;
  String? feedBack;
  String? feedBackColor;
  int? aPTypeID;

  Comments({
    this.aPFeedbackID,
    this.comment,
    this.commentDateTime,
    this.employeeID,
    this.approvalProcessID,
    this.isProxyEmployeeRemarks,
    this.proxyEmployeeRemarks,
    this.orderCommentDateTime,
    this.fullName,
    this.imagePath,
    this.employeeCode,
    this.feedBack,
    this.feedBackColor,
    this.aPTypeID,
  });

  Comments.fromJson(Map<String, dynamic> json) {
    aPFeedbackID = json['APFeedbackID'];
    comment = json['Comment'];
    commentDateTime = json['CommentDateTime'];
    employeeID = json['EmployeeID'];
    approvalProcessID = json['ApprovalProcessID'];
    isProxyEmployeeRemarks = json['IsProxyEmployeeRemarks'];
    proxyEmployeeRemarks = json['ProxyEmployeeRemarks'];
    orderCommentDateTime = json['OrderCommentDateTime'];
    fullName = json['FullName'];
    imagePath = json['ImagePath'];
    employeeCode = json['EmployeeCode'];
    feedBack = json['FeedBack'];
    feedBackColor = json['FeedBackColor'];
    aPTypeID = json['APTypeID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['APFeedbackID'] = aPFeedbackID;
    data['Comment'] = comment;
    data['CommentDateTime'] = commentDateTime;
    data['EmployeeID'] = employeeID;
    data['ApprovalProcessID'] = approvalProcessID;
    data['IsProxyEmployeeRemarks'] = isProxyEmployeeRemarks;
    data['ProxyEmployeeRemarks'] = proxyEmployeeRemarks;
    data['OrderCommentDateTime'] = orderCommentDateTime;
    data['FullName'] = fullName;
    data['ImagePath'] = imagePath;
    data['EmployeeCode'] = employeeCode;
    data['FeedBack'] = feedBack;
    data['FeedBackColor'] = feedBackColor;
    data['APTypeID'] = aPTypeID;
    return data;
  }
}

class RejectedMembers {
  int? value;
  String? label;
  bool? isDisabled;
  String? extraJsonProps;

  RejectedMembers({
    this.value,
    this.label,
    this.isDisabled,
    this.extraJsonProps,
  });

  RejectedMembers.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
    isDisabled = json['isDisabled'];
    extraJsonProps = json['extraJsonProps'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['label'] = label;
    data['isDisabled'] = isDisabled;
    data['extraJsonProps'] = extraJsonProps;
    return data;
  }
}

class LeaveDetails {
  int? eLADBDID;
  String? day;
  String? dayStatus;
  String? dayDateTime;
  bool? isCancel;

  LeaveDetails({
    this.eLADBDID,
    this.day,
    this.dayStatus,
    this.dayDateTime,
    this.isCancel,
  });

  LeaveDetails.fromJson(Map<String, dynamic> json) {
    eLADBDID = json['ELADBDID'];
    day = json['Day'];
    dayStatus = json['DayStatus'];
    dayDateTime = json['DayDateTime'];
    isCancel = json['IsCancel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ELADBDID'] = eLADBDID;
    data['Day'] = day;
    data['DayStatus'] = dayStatus;
    data['DayDateTime'] = dayDateTime;
    data['IsCancel'] = isCancel;
    return data;
  }
}
