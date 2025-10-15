import 'package:erp_solution/models/menu_model.dart';

class UserResult {
  int? logedID;
  int? userID;
  int? personID;
  String? userName;
  String? companyName;
  String? dateFormat;
  String? token;
  String? fullName;
  String? shortName;
  String? imagePath;
  bool? isForcedLogin;
  int? employeeID;
  String? employeeCode;
  String? departmentName;
  String? divisionName;
  String? designationName;
  int? divisionID;
  int? departmentID;
  int? designationID;
  String? companyShortCode;
  String? workMobile;
  String? email;
  String? changePasswordDatetime;
  String? lockedDateTime;
  bool? isLocked;
  Menus? menus;
  int? reasonID;
  String? message;
  String? settings;
  String? shortcuts;
  String? redirectUrl;
  bool? hasPermissionForChangeUser;

  UserResult({
    this.logedID,
    this.userID,
    this.personID,
    this.userName,
    this.companyName,
    this.dateFormat,
    this.token,
    this.fullName,
    this.shortName,
    this.imagePath,
    this.isForcedLogin,
    this.employeeID,
    this.employeeCode,
    this.departmentName,
    this.divisionName,
    this.designationName,
    this.divisionID,
    this.departmentID,
    this.designationID,
    this.companyShortCode,
    this.workMobile,
    this.email,
    this.changePasswordDatetime,
    this.lockedDateTime,
    this.isLocked,
    this.menus,
    this.reasonID,
    this.message,
    this.settings,
    this.shortcuts,
    this.redirectUrl,
    this.hasPermissionForChangeUser,
  });

  UserResult.fromJson(Map<String, dynamic> json) {
    logedID = json['LogedID'];
    userID = json['UserID'];
    personID = json['PersonID'];
    userName = json['UserName'];
    companyName = json['CompanyName'];
    dateFormat = json['DateFormat'];
    token = json['Token'];
    fullName = json['FullName'];
    shortName = json['ShortName'];
    imagePath = json['ImagePath'];
    isForcedLogin = json['IsForcedLogin'];
    employeeID = json['EmployeeID'];
    employeeCode = json['EmployeeCode'];
    departmentName = json['DepartmentName'];
    divisionName = json['DivisionName'];
    designationName = json['DesignationName'];
    divisionID = json['DivisionID'];
    departmentID = json['DepartmentID'];
    designationID = json['DesignationID'];
    companyShortCode = json['CompanyShortCode'];
    workMobile = json['WorkMobile'];
    email = json['Email'];
    changePasswordDatetime = json['ChangePasswordDatetime'];
    lockedDateTime = json['LockedDateTime'];
    isLocked = json['IsLocked'];
    menus = json['menus'] != null ? Menus.fromJson(json['menus']) : null;
    reasonID = json['ReasonID'];
    message = json['Message'];
    settings = json['Settings'];
    shortcuts = json['Shortcuts'];
    redirectUrl = json['RedirectUrl'];
    hasPermissionForChangeUser = json['HasPermissionForChangeUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['LogedID'] = logedID;
    data['UserID'] = userID;
    data['PersonID'] = personID;
    data['UserName'] = userName;
    data['CompanyName'] = companyName;
    data['DateFormat'] = dateFormat;
    data['Token'] = token;
    data['FullName'] = fullName;
    data['ShortName'] = shortName;
    data['ImagePath'] = imagePath;
    data['IsForcedLogin'] = isForcedLogin;
    data['EmployeeID'] = employeeID;
    data['EmployeeCode'] = employeeCode;
    data['DepartmentName'] = departmentName;
    data['DivisionName'] = divisionName;
    data['DesignationName'] = designationName;
    data['DivisionID'] = divisionID;
    data['DepartmentID'] = departmentID;
    data['DesignationID'] = designationID;
    data['CompanyShortCode'] = companyShortCode;
    data['WorkMobile'] = workMobile;
    data['Email'] = email;
    data['ChangePasswordDatetime'] = changePasswordDatetime;
    data['LockedDateTime'] = lockedDateTime;
    data['IsLocked'] = isLocked;
    if (menus != null) {
      data['menus'] = menus!.toJson();
    }
    data['ReasonID'] = reasonID;
    data['Message'] = message;
    data['Settings'] = settings;
    data['Shortcuts'] = shortcuts;
    data['RedirectUrl'] = redirectUrl;
    data['HasPermissionForChangeUser'] = hasPermissionForChangeUser;
    return data;
  }
}
