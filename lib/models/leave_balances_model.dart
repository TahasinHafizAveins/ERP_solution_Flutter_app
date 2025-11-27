class LeaveBalances {
  int? employeeID;
  int? leaveCategoryID;
  String? systemVariableCode;
  double? leaveDays;
  double? noOfApprovedLeaveDays;
  double? noOfPendingLeaveDays;
  double? applying;
  double? balance;
  double? previousLeaveDays;
  double? encashBalance;

  LeaveBalances({
    this.employeeID,
    this.leaveCategoryID,
    this.systemVariableCode,
    this.leaveDays,
    this.noOfApprovedLeaveDays,
    this.noOfPendingLeaveDays,
    this.applying,
    this.balance,
    this.previousLeaveDays,
    this.encashBalance,
  });

  LeaveBalances.fromJson(Map<String, dynamic> json) {
    employeeID = json['EmployeeID'];
    leaveCategoryID = json['LeaveCategoryID'];
    systemVariableCode = json['SystemVariableCode'];
    leaveDays = json['LeaveDays'];
    noOfApprovedLeaveDays = json['NoOfApprovedLeaveDays'];
    noOfPendingLeaveDays = json['NoOfPendingLeaveDays'];
    applying = json['Applying'];
    balance = json['Balance'];
    previousLeaveDays = json['PreviousLeaveDays'];
    encashBalance = json['EncashBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['EmployeeID'] = employeeID;
    data['LeaveCategoryID'] = leaveCategoryID;
    data['SystemVariableCode'] = systemVariableCode;
    data['LeaveDays'] = leaveDays;
    data['NoOfApprovedLeaveDays'] = noOfApprovedLeaveDays;
    data['NoOfPendingLeaveDays'] = noOfPendingLeaveDays;
    data['Applying'] = applying;
    data['Balance'] = balance;
    data['PreviousLeaveDays'] = previousLeaveDays;
    data['EncashBalance'] = encashBalance;
    return data;
  }
}
