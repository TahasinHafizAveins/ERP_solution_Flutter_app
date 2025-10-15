class NotificationModel {
  String? orderFeedbackRequestDate;
  String? description;
  String? feedbackRequestDate;
  String? referenceID;
  int? approvalProcessID;
  String? aPEmployeeFeedbackID;
  int? aPTypeID;
  String? aPTypeName;
  int? aPForwardInfoID;
  String? title;
  int? isAPEditable;
  int? aPFeedbackID;
  int? isEditable;
  int? isSCM;
  int? isMultiProxy;
  int? departmentID;
  String? proxy;
  String? particulars;
  int? totalRows;

  NotificationModel({
    this.orderFeedbackRequestDate,
    this.description,
    this.feedbackRequestDate,
    this.referenceID,
    this.approvalProcessID,
    this.aPEmployeeFeedbackID,
    this.aPTypeID,
    this.aPTypeName,
    this.aPForwardInfoID,
    this.title,
    this.isAPEditable,
    this.aPFeedbackID,
    this.isEditable,
    this.isSCM,
    this.isMultiProxy,
    this.departmentID,
    this.proxy,
    this.particulars,
    this.totalRows,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    orderFeedbackRequestDate = json['OrderFeedbackRequestDate'];
    description = json['Description'];
    feedbackRequestDate = json['FeedbackRequestDate'];
    referenceID = json['ReferenceID'];
    approvalProcessID = json['ApprovalProcessID'];
    aPEmployeeFeedbackID = json['APEmployeeFeedbackID'];
    aPTypeID = json['APTypeID'];
    aPTypeName = json['APTypeName'];
    aPForwardInfoID = json['APForwardInfoID'];
    title = json['Title'];
    isAPEditable = json['IsAPEditable'];
    aPFeedbackID = json['APFeedbackID'];
    isEditable = json['IsEditable'];
    isSCM = json['IsSCM'];
    isMultiProxy = json['IsMultiProxy'];
    departmentID = json['DepartmentID'];
    proxy = json['Proxy'];
    particulars = json['Particulars'];
    totalRows = json['TotalRows'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OrderFeedbackRequestDate'] = orderFeedbackRequestDate;
    data['Description'] = description;
    data['FeedbackRequestDate'] = feedbackRequestDate;
    data['ReferenceID'] = referenceID;
    data['ApprovalProcessID'] = approvalProcessID;
    data['APEmployeeFeedbackID'] = aPEmployeeFeedbackID;
    data['APTypeID'] = aPTypeID;
    data['APTypeName'] = aPTypeName;
    data['APForwardInfoID'] = aPForwardInfoID;
    data['Title'] = title;
    data['IsAPEditable'] = isAPEditable;
    data['APFeedbackID'] = aPFeedbackID;
    data['IsEditable'] = isEditable;
    data['IsSCM'] = isSCM;
    data['IsMultiProxy'] = isMultiProxy;
    data['DepartmentID'] = departmentID;
    data['Proxy'] = proxy;
    data['Particulars'] = particulars;
    data['TotalRows'] = totalRows;
    return data;
  }
}
