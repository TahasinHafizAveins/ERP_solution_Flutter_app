class RemoteAttendanceModel {
  Result? result;
  String? message;
  String? responseCode;
  int? statusCode;
  RemoteAttendanceModel({
    this.result,
    this.message,
    this.responseCode,
    this.statusCode,
  });

  RemoteAttendanceModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'] != null ? Result.fromJson(json['Result']) : null;
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

class Result {
  String? inTime;
  String? outTime;
  bool? isRemoteIP;
  List<AttendanceModel>? attendanceList;
  String? employeeNote;
  Location? division;
  Location? district;
  String? iPAddress;
  String? lastEntryType;

  Result({
    this.inTime,
    this.outTime,
    this.isRemoteIP,
    this.attendanceList,
    this.employeeNote,
    this.division,
    this.district,
    this.iPAddress,
    this.lastEntryType,
  });

  Result.fromJson(Map<String, dynamic> json) {
    inTime = json['In_Time'];
    outTime = json['Out_Time'];
    isRemoteIP = json['IsRemoteIP'];
    if (json['AttendanceList'] != null) {
      attendanceList = <AttendanceModel>[];
      json['AttendanceList'].forEach((v) {
        attendanceList!.add(AttendanceModel.fromJson(v));
      });
    }
    employeeNote = json['EmployeeNote'];
    division = json['Division'] != null
        ? Location.fromJson(json['Division'])
        : null;
    district = json['District'] != null
        ? Location.fromJson(json['District'])
        : null;
    iPAddress = json['IPAddress'];
    lastEntryType = json['LastEntryType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['In_Time'] = inTime;
    data['Out_Time'] = outTime;
    data['IsRemoteIP'] = isRemoteIP;
    if (attendanceList != null) {
      data['AttendanceList'] = attendanceList!.map((v) => v.toJson()).toList();
    }
    data['EmployeeNote'] = employeeNote;
    if (division != null) {
      data['Division'] = division!.toJson();
    }
    if (district != null) {
      data['District'] = district!.toJson();
    }
    data['IPAddress'] = iPAddress;
    data['LastEntryType'] = lastEntryType;
    return data;
  }
}

class AttendanceModel {
  int? rAID;
  String? attendanceDate;
  int? employeeID;
  String? employeeNote;
  String? entryType;
  int? statusID;
  int? approverID;
  String? approvarNote;
  String? approvalDate;
  String? statusName;
  String? approverName;
  String? approverNote;
  String? employeeCode;
  String? employeeName;
  String? employeeImagePath;
  String? approverImagePath;
  String? channel;
  int? districtID;
  int? divisionID;
  int? thanaID;
  String? area;
  String? longitude;
  String? latitude;
  String? divisionName;
  String? districtName;
  String? thanaName;
  String? inTimeError;
  String? selectedIds;
  String? companyID;
  int? createdBy;
  String? createdDate;
  String? createdIP;
  int? rowVersion;
  String? rowEditorStatus;

  AttendanceModel({
    this.rAID,
    this.attendanceDate,
    this.employeeID,
    this.employeeNote,
    this.entryType,
    this.statusID,
    this.approverID,
    this.approvarNote,
    this.approvalDate,
    this.statusName,
    this.approverName,
    this.approverNote,
    this.employeeCode,
    this.employeeName,
    this.employeeImagePath,
    this.approverImagePath,
    this.channel,
    this.districtID,
    this.divisionID,
    this.thanaID,
    this.area,
    this.longitude,
    this.latitude,
    this.divisionName,
    this.districtName,
    this.thanaName,
    this.inTimeError,
    this.selectedIds,
    this.companyID,
    this.createdBy,
    this.createdDate,
    this.createdIP,
    this.rowVersion,
    this.rowEditorStatus,
  });

  AttendanceModel.fromJson(Map<String, dynamic> json) {
    rAID = json['RAID'];
    attendanceDate = json['AttendanceDate'];
    employeeID = json['EmployeeID'];
    employeeNote = json['EmployeeNote'];
    entryType = json['EntryType'];
    statusID = json['StatusID'];
    approverID = json['ApproverID'];
    approvarNote = json['ApprovarNote'];
    approvalDate = json['ApprovalDate'];
    statusName = json['StatusName'];
    approverName = json['ApproverName'];
    approverNote = json['ApproverNote'];
    employeeCode = json['EmployeeCode'];
    employeeName = json['EmployeeName'];
    employeeImagePath = json['EmployeeImagePath'];
    approverImagePath = json['ApproverImagePath'];
    channel = json['Channel'];
    districtID = json['DistrictID'];
    divisionID = json['DivisionID'];
    thanaID = json['ThanaID'];
    area = json['Area'];
    longitude = json['Longitude'];
    latitude = json['Latitude'];
    divisionName = json['DivisionName'];
    districtName = json['DistrictName'];
    thanaName = json['ThanaName'];
    inTimeError = json['InTimeError'];
    selectedIds = json['SelectedIds'];
    companyID = json['CompanyID'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    createdIP = json['CreatedIP'];
    rowVersion = json['RowVersion'];
    rowEditorStatus = json['RowEditorStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RAID'] = rAID;
    data['AttendanceDate'] = attendanceDate;
    data['EmployeeID'] = employeeID;
    data['EmployeeNote'] = employeeNote;
    data['EntryType'] = entryType;
    data['StatusID'] = statusID;
    data['ApproverID'] = approverID;
    data['ApprovarNote'] = approvarNote;
    data['ApprovalDate'] = approvalDate;
    data['StatusName'] = statusName;
    data['ApproverName'] = approverName;
    data['ApproverNote'] = approverNote;
    data['EmployeeCode'] = employeeCode;
    data['EmployeeName'] = employeeName;
    data['EmployeeImagePath'] = employeeImagePath;
    data['ApproverImagePath'] = approverImagePath;
    data['Channel'] = channel;
    data['DistrictID'] = districtID;
    data['DivisionID'] = divisionID;
    data['ThanaID'] = thanaID;
    data['Area'] = area;
    data['Longitude'] = longitude;
    data['Latitude'] = latitude;
    data['DivisionName'] = divisionName;
    data['DistrictName'] = districtName;
    data['ThanaName'] = thanaName;
    data['InTimeError'] = inTimeError;
    data['SelectedIds'] = selectedIds;
    data['CompanyID'] = companyID;
    data['CreatedBy'] = createdBy;
    data['CreatedDate'] = createdDate;
    data['CreatedIP'] = createdIP;
    data['RowVersion'] = rowVersion;
    data['RowEditorStatus'] = rowEditorStatus;
    return data;
  }
}

class Location {
  int? value;
  String? label;

  Location({this.value, this.label});

  Location.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['label'] = label;
    return data;
  }
}
