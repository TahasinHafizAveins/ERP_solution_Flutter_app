class NotificationTypeModel {
  int? aPTypeID;
  String? aPTypeName;
  int? totalRows;

  NotificationTypeModel({this.aPTypeID, this.aPTypeName, this.totalRows});

  NotificationTypeModel.fromJson(Map<String, dynamic> json) {
    aPTypeID = json['APTypeID'];
    aPTypeName = json['APTypeName'];
    totalRows = json['TotalRows'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['APTypeID'] = aPTypeID;
    data['APTypeName'] = aPTypeName;
    data['TotalRows'] = totalRows;
    return data;
  }
}
