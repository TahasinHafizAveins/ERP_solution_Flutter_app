class BulkApprovalItem {
  final int employeeLeaveAID;
  final int approvalProcessID;
  final int apEmployeeFeedbackID;
  final int apTypeID;
  final int apForwardInfoID;
  final String method;
  final int referenceID;
  final String approvalType;
  final int apFeedbackID;
  final String? status;
  final String comment;
  final dynamic rejectionMember;
  final dynamic forwardingMember;

  BulkApprovalItem({
    required this.employeeLeaveAID,
    required this.approvalProcessID,
    required this.apEmployeeFeedbackID,
    this.apTypeID = 1,
    this.apForwardInfoID = 0,
    this.method = 'GetLeaveApplicationDetails',
    required this.referenceID,
    required this.approvalType,
    required this.apFeedbackID,
    this.status,
    required this.comment,
    this.rejectionMember,
    this.forwardingMember,
  });

  Map<String, dynamic> toJson() {
    return {
      'EmployeeLeaveAID': employeeLeaveAID,
      'ApprovalProcessID': approvalProcessID,
      'APEmployeeFeedbackID': apEmployeeFeedbackID,
      'APTypeID': apTypeID,
      'APForwardInfoID': apForwardInfoID,
      'method': method,
      'ReferenceID': referenceID,
      'approvalType': approvalType,
      'APFeedbackID': apFeedbackID,
      'Status': status,
      'Comment': comment,
      'RejectionMember': rejectionMember,
      'ForwardingMember': forwardingMember,
    };
  }
}

class BulkApprovalPayload {
  final List<BulkApprovalItem> bulkList;

  BulkApprovalPayload({required this.bulkList});

  Map<String, dynamic> toJson() {
    return {'bulkList': bulkList.map((item) => item.toJson()).toList()};
  }
}
