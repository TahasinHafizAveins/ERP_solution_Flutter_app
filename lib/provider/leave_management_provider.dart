import 'package:erp_solution/models/leave_application_list_model.dart';
import 'package:erp_solution/models/pending_bulk_leave_application_model.dart';
import 'package:erp_solution/service/leave_management_service.dart';
import 'package:flutter/material.dart';

import '../models/bulk_approva_iItem_model.dart';
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
  bool _isBulkApprovalLoading = false;
  bool _isPendingApplicationsLoading = false;

  String? _balanceLeaveError;
  String? _backupEmpError;
  String? _error;
  String? _submitLeaveError;
  String? _teamLeaveError;
  String? _leaveApplicationDetailsError;
  String? _bulkApprovalError;
  String? _pendingApplicationsError;

  List<LeaveApplicationListModel> _leaveApplicationList = [];
  List<LeaveApplicationListModel> _teamleaveApplicationList = [];
  List<LeaveBalances> _leaveBalances = [];
  List<RejectedMembers> _backupEmp = [];
  Map<String, dynamic>? _submitLeaveData = {};
  List<dynamic> _leaveApplicationDetails = [];
  Map<String, dynamic>? _bulkApprovalData;
  List<PendingLeaveApplication> _pendingApplications = [];

  bool get isLoading => _isLoading;
  bool get isBalanceLeaveLoading => _isBalaceLeaveLoading;
  bool get isBackupEmpLoading => _isBackupEmpLoading;
  bool get isSubmitLeaveLoading => _isSubmitLeaveLoading;
  bool get isTeamLeaveLoading => _isTeamLeaveLoading;
  bool get isLeaveApplicationDetailsLoading =>
      _isLeaveApplicationDetailsLoading;
  bool get isBulkApprovalLoading => _isBulkApprovalLoading;
  bool get isPendingApplicationsLoading => _isPendingApplicationsLoading;

  String? get error => _error;
  String? get balanceLeaveError => _balanceLeaveError;
  String? get backupEmpError => _backupEmpError;
  String? get submitLeaveError => _submitLeaveError;
  String? get teamLeaveError => _teamLeaveError;
  String? get leaveApplicationDetailsError => _leaveApplicationDetailsError;
  String? get bulkApprovalError => _bulkApprovalError;
  String? get pendingApplicationsError => _pendingApplicationsError;

  List<LeaveApplicationListModel> get leaveApplications =>
      _leaveApplicationList;
  List<LeaveApplicationListModel> get teamLeaveApplications =>
      _teamleaveApplicationList;
  List<LeaveBalances> get leaveBalances => _leaveBalances;
  List<RejectedMembers> get backupEmp => _backupEmp;
  Map<String, dynamic>? get submitLeaveData => _submitLeaveData;
  List<dynamic> get leaveApplicationDetails => _leaveApplicationDetails;
  Map<String, dynamic>? get bulkApprovalData => _bulkApprovalData;
  List<PendingLeaveApplication> get pendingApplications => _pendingApplications;

  bool _isSubmitLeaveApprovalLoading = false;
  String? _submitLeaveApprovalError;
  Map<String, dynamic>? _submitLeaveApprovalData;

  // Getters
  bool get isSubmitLeaveApprovalLoading => _isSubmitLeaveApprovalLoading;
  String? get submitLeaveApprovalError => _submitLeaveApprovalError;
  Map<String, dynamic>? get submitLeaveApprovalData => _submitLeaveApprovalData;

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

  Future<bool> submitLeaveApproval(Map<String, dynamic> approvalData) async {
    _isSubmitLeaveApprovalLoading = true;
    _submitLeaveApprovalError = null;
    _submitLeaveApprovalData = null;
    notifyListeners();

    try {
      final response = await service.submitLeaveApproval(approvalData);

      bool status = response['status'];
      String message = response['message'];

      if (status) {
        _submitLeaveApprovalData = response;
        return true; // Success
      } else {
        _submitLeaveApprovalData = null;
        _submitLeaveApprovalError = message;
        return false; // Failure
      }
    } catch (e) {
      _isSubmitLeaveApprovalLoading = false;
      _submitLeaveApprovalError = e.toString();
      _submitLeaveApprovalData = null;
      notifyListeners();
      return false; // Failure
    } finally {
      _isSubmitLeaveApprovalLoading = false;
      notifyListeners();
    }
  }

  // Fetch pending applications for bulk approval
  Future<void> loadPendingApplications() async {
    _isPendingApplicationsLoading = true;
    _pendingApplicationsError = null;
    _pendingApplications = [];
    notifyListeners();

    try {
      _pendingApplications = await service.fetchPendingLeaveApplications();
    } catch (e) {
      _pendingApplicationsError = e.toString();
    } finally {
      _isPendingApplicationsLoading = false;
      notifyListeners();
    }
  }

  // Submit bulk approval/rejection
  Future<bool> submitBulkLeaveApproval(BulkApprovalPayload payload) async {
    _isBulkApprovalLoading = true;
    _bulkApprovalError = null;
    _bulkApprovalData = null;
    notifyListeners();

    try {
      final response = await service.submitBulkLeaveApproval(payload);

      bool status = response['status'] ?? false;
      String message = response['message'] ?? '';

      if (status) {
        _bulkApprovalData = response;
        return true;
      } else {
        _bulkApprovalData = null;
        _bulkApprovalError = message;
        return false;
      }
    } catch (e) {
      _isBulkApprovalLoading = false;
      _bulkApprovalError = e.toString();
      _bulkApprovalData = null;
      notifyListeners();
      return false;
    } finally {
      _isBulkApprovalLoading = false;
      notifyListeners();
    }
  }
}
