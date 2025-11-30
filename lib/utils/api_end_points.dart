class ApiEndPoints {
  static const String base = "https://nagaderp.mynagad.com:7070";

  ///Authentication & Menu for Sidebar Drawer
  static const String loginApi = "/Security/User/SignInWithMenus";

  ///Images
  static const String imageApi = "/Security/";

  ///Notifications
  static const String notificationListApi =
      "/Security/Notification/GetNotificationList";
  static const String notificationTypesApi =
      "/Security/Notification/GetAPTypeList";

  ///Attendance
  static const String attendanceSummaryApi =
      "/HRMS/Attendance/GetAttendanceWidgets/0";
  static const String getAttendanceBarChartApi =
      "/HRMS/Attendance/GetEmployeeAttendanceSummaryBarchart/0";
  static const String teamMemAttendanceDetailsApi =
      "/HRMS/Attendance/getSelfAttendanceWidget/";

  ///Employee Directory
  static const String employeeDirectoryApi =
      "/HRMS/Employee/GetAllEmployeeDirectory";

  ///Remote Attendance
  static const String remoteAttendanceListApi =
      "/HRMS/Attendance/GetRemoteAttendance";
  static const String remoteAttendanceSubmitApi =
      "/HRMS/Attendance/SaveRemoteAttendance";
  static const String divisionOfCountryApi =
      "/security/combo/getdivisionofcountry";
  static const String districtsByDivisionApi =
      "/security/combo/GetDistrictsByDivision/";
  static const String thanaByDistrictApi = "/security/combo/GetThanas/";

  ///Leave Management
  static const String selfLeaveApplicationListApi =
      "/HRMS/Leave/GetLeaveApplicationList";
  static const String allLeaveApplicationListApi =
      "/HRMS/Leave/GetAllLeaveApplicationList";

  static const String submitLeaveApplication =
      "/HRMS/Leave/CreateLeaveApplication";
  static const String submitLeaveApproval =
      "/Approval/ApprovalRequest/ApprovalSubmission";
  static const String getApprovalList = "/Approval/APView/GetAPViews";
  static const String getLeaveBalanceDetails =
      "/HRMS/Leave/GetLeaveBalanceAndDetails/";
  static const String getBackupEmp = "/HRMS/Combo/GetBackupEmployees";
}
