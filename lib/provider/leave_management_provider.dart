import 'package:erp_solution/models/leave_application_list_model.dart';
import 'package:erp_solution/service/leave_management_service.dart';
import 'package:flutter/material.dart';

import '../models/leave_balances_model.dart';
import '../models/self_leave_application_details_model.dart';

class LeaveManagementProvider with ChangeNotifier {
  final LeaveManagementService service;

  LeaveManagementProvider(this.service);

  bool _isLoading = false;
  bool _isBalaceLeaveLoading = false;
  bool _isBackupEmpLoading = false;
  bool _isSubmitLeaveLoading = false;
  String? _balanceLeaveError;
  String? _backupEmpError;
  String? _error;
  String? _submitLeaveError;

  List<LeaveApplicationListModel> _leaveApplicationList = [];
  List<LeaveBalances> _leaveBalances = [];
  List<RejectedMembers> _backupEmp = [];
  Map<String, dynamic> _submitLeaveData = {};

  bool get isLoading => _isLoading;
  bool get isBalanceLeaveLoading => _isBalaceLeaveLoading;
  bool get isBackupEmpLoading => _isBackupEmpLoading;
  bool get isSubmitLeaveLoading => _isSubmitLeaveLoading;
  String? get error => _error;
  String? get balanceLeaveError => _balanceLeaveError;
  String? get backupEmpError => _backupEmpError;
  String? get submitLeaveError => _submitLeaveError;

  List<LeaveApplicationListModel> get leaveApplications =>
      _leaveApplicationList;
  List<LeaveBalances> get leaveBalances => _leaveBalances;
  List<RejectedMembers> get backupEmp => _backupEmp;
  Map<String, dynamic> get submitLeaveData => _submitLeaveData;

  Future<void> loadLeaveApplicationList() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _leaveApplicationList = await service.fetchSelfLeaveApplicationList();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadLeaveBalanceDetails(
    String leaveCategoryId,
    String startDate,
    String endDate,
  ) async {
    _isBalaceLeaveLoading = true;
    _balanceLeaveError = null;
    notifyListeners();

    try {
      _leaveBalances = (await service.fetchLeaveBalanceDetails(
        leaveCategoryId,
        startDate,
        endDate,
      ));
    } catch (e) {
      _isBalaceLeaveLoading = false;
      _balanceLeaveError = e.toString();
    } finally {
      _isBalaceLeaveLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBackupEmp() async {
    _isBackupEmpLoading = true;
    _backupEmpError = null;
    notifyListeners();

    try {
      _backupEmp = await service.fetchBackupEmp();
    } catch (e) {
      _isBackupEmpLoading = false;
      _backupEmpError = e.toString();
    } finally {
      _isBackupEmpLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitLeaveApplication(Map<String, dynamic> leaveData) async {
    _isSubmitLeaveLoading = true;
    _submitLeaveError = null;
    notifyListeners();
    try {
      _submitLeaveData = await service.submitLeaveApplication(leaveData);
    } catch (e) {
      _isSubmitLeaveLoading = false;
      _submitLeaveError = e.toString();
    } finally {
      _isSubmitLeaveLoading = false;
      notifyListeners();
    }
  }
}
