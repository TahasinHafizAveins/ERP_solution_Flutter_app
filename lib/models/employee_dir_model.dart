class EmployeeDirModel {
  String? autoGenRowNum;
  int? employeeID;
  String? employeeCode;
  String? fullName;
  int? employeeTypeID;
  String? employeeStatus;
  String? imagePath;
  String? workEmail;
  int? employeeStatusID;
  String? employeeNameWithCode;
  String? employeeDivDeptDesg;
  String? divisionName;
  String? departmentName;
  String? designationName;
  String? genderName;
  String? workEmailPhone;
  String? workMobile;
  String? supervisorInfo;
  String? supervisorFullName;
  String? supervisorEmail;

  EmployeeDirModel({
    this.autoGenRowNum,
    this.employeeID,
    this.employeeCode,
    this.fullName,
    this.employeeTypeID,
    this.employeeStatus,
    this.imagePath,
    this.workEmail,
    this.employeeStatusID,
    this.employeeNameWithCode,
    this.employeeDivDeptDesg,
    this.divisionName,
    this.departmentName,
    this.designationName,
    this.genderName,
    this.workEmailPhone,
    this.workMobile,
    this.supervisorInfo,
    this.supervisorFullName,
    this.supervisorEmail,
  });

  EmployeeDirModel.fromJson(Map<String, dynamic> json) {
    autoGenRowNum = json['AutoGenRowNum'];
    employeeID = json['EmployeeID'];
    employeeCode = json['EmployeeCode'];
    fullName = json['FullName'];
    employeeTypeID = json['EmployeeTypeID'];
    employeeStatus = json['EmployeeStatus'];
    imagePath = json['ImagePath'];
    workEmail = json['WorkEmail'];
    employeeStatusID = json['EmployeeStatusID'];
    employeeNameWithCode = json['EmployeeNameWithCode'];
    employeeDivDeptDesg = json['EmployeeDivDeptDesg'];
    divisionName = json['DivisionName'];
    departmentName = json['DepartmentName'];
    designationName = json['DesignationName'];
    genderName = json['GenderName'];
    workEmailPhone = json['WorkEmailPhone'];
    workMobile = json['WorkMobile'];
    supervisorInfo = json['SupervisorInfo'];
    supervisorFullName = json['SupervisorFullName'];
    supervisorEmail = json['SupervisorEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AutoGenRowNum'] = autoGenRowNum;
    data['EmployeeID'] = employeeID;
    data['EmployeeCode'] = employeeCode;
    data['FullName'] = fullName;
    data['EmployeeTypeID'] = employeeTypeID;
    data['EmployeeStatus'] = employeeStatus;
    data['ImagePath'] = imagePath;
    data['WorkEmail'] = workEmail;
    data['EmployeeStatusID'] = employeeStatusID;
    data['EmployeeNameWithCode'] = employeeNameWithCode;
    data['EmployeeDivDeptDesg'] = employeeDivDeptDesg;
    data['DivisionName'] = divisionName;
    data['DepartmentName'] = departmentName;
    data['DesignationName'] = designationName;
    data['GenderName'] = genderName;
    data['WorkEmailPhone'] = workEmailPhone;
    data['WorkMobile'] = workMobile;
    data['SupervisorInfo'] = supervisorInfo;
    data['SupervisorFullName'] = supervisorFullName;
    data['SupervisorEmail'] = supervisorEmail;
    return data;
  }
}
