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
  bool _isTeamLeaveLoading = false;
  bool _isLeaveApplicationDetailsLoading = false;

  String? _balanceLeaveError;
  String? _backupEmpError;
  String? _error;
  String? _submitLeaveError;
  String? _teamLeaveError;
  String? _leaveApplicationDetailsError;

  List<LeaveApplicationListModel> _leaveApplicationList = [];
  List<LeaveApplicationListModel> _teamleaveApplicationList = [];
  List<LeaveBalances> _leaveBalances = [];
  List<RejectedMembers> _backupEmp = [];
  Map<String, dynamic>? _submitLeaveData = {};
  List<dynamic> _leaveApplicationDetails = [];

  bool get isLoading => _isLoading;
  bool get isBalanceLeaveLoading => _isBalaceLeaveLoading;
  bool get isBackupEmpLoading => _isBackupEmpLoading;
  bool get isSubmitLeaveLoading => _isSubmitLeaveLoading;
  bool get isTeamLeaveLoading => _isTeamLeaveLoading;
  bool get isLeaveApplicationDetailsLoading =>
      _isLeaveApplicationDetailsLoading;

  String? get error => _error;
  String? get balanceLeaveError => _balanceLeaveError;
  String? get backupEmpError => _backupEmpError;
  String? get submitLeaveError => _submitLeaveError;
  String? get teamLeaveError => _teamLeaveError;
  String? get leaveApplicationDetailsError => _leaveApplicationDetailsError;

  List<LeaveApplicationListModel> get leaveApplications =>
      _leaveApplicationList;
  List<LeaveApplicationListModel> get teamLeaveApplications =>
      _teamleaveApplicationList;
  List<LeaveBalances> get leaveBalances => _leaveBalances;
  List<RejectedMembers> get backupEmp => _backupEmp;
  Map<String, dynamic>? get submitLeaveData => _submitLeaveData;
  List<dynamic> get leaveApplicationDetails => _leaveApplicationDetails;

  Future<void> loadSelfLeaveApplicationList() async {
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

  Future<void> loadTeamLeaveApplicationList() async {
    _isTeamLeaveLoading = true;
    _teamLeaveError = null;
    notifyListeners();

    try {
      _teamleaveApplicationList = await service.fetchTeamLeaveApplicationList();
    } catch (e) {
      _isTeamLeaveLoading = false;
      _teamLeaveError = e.toString();
    } finally {
      _isTeamLeaveLoading = false;
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

  Future<bool> submitLeaveApplication(Map<String, dynamic> leaveData) async {
    _isSubmitLeaveLoading = true;
    _submitLeaveError = null;
    _submitLeaveData = null;
    notifyListeners();

    try {
      final response = await service.submitLeaveApplication(leaveData);

      bool status = response['status'];
      String message = response['message'];

      if (status) {
        _submitLeaveData = response;
        return true; // Success
      } else {
        _submitLeaveData = null;
        _submitLeaveError = message;
        return false; // Failure
      }
    } catch (e) {
      _isSubmitLeaveLoading = false;
      _submitLeaveError = e.toString();
      _submitLeaveData = null;
      notifyListeners();
      return false; // Failure
    } finally {
      _isSubmitLeaveLoading = false;
      notifyListeners();
    }
  }

  Future<void> getLeaveApplicationDetails({
    required int type,
    required int ref,
  }) async {
    _isLeaveApplicationDetailsLoading = true;
    _leaveApplicationDetailsError = null;
    notifyListeners();

    try {
      final response = await service.getLeaveApplicationDetails(
        type: type,
        ref: ref,
      );
      _leaveApplicationDetails = response;
    } catch (e) {
      _isLeaveApplicationDetailsLoading = false;
      _leaveApplicationDetailsError = e.toString();
      _leaveApplicationDetails = []; // Reset to empty list on error
    } finally {
      _isLeaveApplicationDetailsLoading = false;
      notifyListeners();
    }
  }
}
