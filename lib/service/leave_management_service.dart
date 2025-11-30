import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:erp_solution/models/leave_application_list_model.dart';
import 'package:erp_solution/models/leave_balances_model.dart';
import 'package:erp_solution/models/self_leave_application_details_model.dart';
import 'package:erp_solution/service/api_service.dart';
import 'package:erp_solution/utils/api_end_points.dart';

class LeaveManagementService {
  final ApiService apiService;
  LeaveManagementService(this.apiService);

  Future<List<LeaveApplicationListModel>>
  fetchSelfLeaveApplicationList() async {
    try {
      final response = await apiService.dio.post(
        ApiEndPoints.selfLeaveApplicationListApi,
        data: {
          'ServerPagination': true,
          'Limit': 1000,
          'Offset': 0,
          'Order': 'desc',
          'SearchBy': '',
          'SearchType': '',
          'Search': '',
          'Sort': 'CreatedDate',
          'SortName': '',
          'SortOrder': '',
          'ApprovalFilterData': 'All',
          'formType': 'employee',
        },
      );

      // Parse the response
      final responseData = response.data;

      // If response.data is already a Map, no need to decode
      final result = responseData is String
          ? json.decode(responseData)
          : responseData;

      final responseBody = result['Result']['parentDataSource'];

      final List<dynamic> rows = responseBody['Rows'];

      final applications = rows
          .map<LeaveApplicationListModel>(
            (json) => LeaveApplicationListModel.fromJson(json),
          )
          .toList();

      return applications;
    } on DioException catch (e) {
      throw Exception(
        "Fetch failed: ${e.response?.data ?? e.message ?? "Unknown error"}",
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LeaveApplicationListModel>>
  fetchTeamLeaveApplicationList() async {
    try {
      final response = await apiService.dio.post(
        ApiEndPoints.allLeaveApplicationListApi,
        data: {
          'ServerPagination': true,
          'Limit': 100,
          'Offset': 0,
          'Order': 'desc',
          'SearchBy':
              'EmployeeName\$EmployeeCode\$LeaveType\$LeaveDates\$ApprovalStatus',
          'SearchType': '',
          'Search': '\$\$\$\$',
          'Sort': 'CreatedDate',
          'SortName': '',
          'SortOrder': '',
          'ApprovalFilterData': 'All',
        },
      );

      // Parse the response
      final responseData = response.data;

      // If response.data is already a Map, no need to decode
      final result = responseData is String
          ? json.decode(responseData)
          : responseData;

      final responseBody = result['Result']['parentDataSource'];

      final List<dynamic> rows = responseBody['Rows'];

      final applications = rows
          .map<LeaveApplicationListModel>(
            (json) => LeaveApplicationListModel.fromJson(json),
          )
          .toList();

      return applications;
    } on DioException catch (e) {
      throw Exception(
        "Fetch failed: ${e.response?.data ?? e.message ?? "Unknown error"}",
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LeaveBalances>> fetchLeaveBalanceDetails(
    String leaveCategoryId,
    String startDate,
    String endDate,
  ) async {
    try {
      final response = await apiService.dio.get(
        '${ApiEndPoints.getLeaveBalanceDetails}/$leaveCategoryId/$startDate/$endDate/0',
      );
      final responseData = response.data['Result'];
      final List<dynamic> leaveBalancesJson = responseData['LeaveBalances'];
      return leaveBalancesJson
          .map<LeaveBalances>((json) => LeaveBalances.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RejectedMembers>> fetchBackupEmp() async {
    try {
      final response = await apiService.dio.get(ApiEndPoints.getBackupEmp);
      final responseData = response.data['Result'];
      return responseData
          .map<RejectedMembers>((json) => RejectedMembers.fromJson(json))
          .toList();
      ;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> submitLeaveApplication(
    Map<String, dynamic> leaveData,
  ) async {
    try {
      final response = await apiService.dio.post(
        ApiEndPoints.submitLeaveApplication,
        data: leaveData,
      );
      final responseData = response.data['Result'];
      return Map<String, dynamic>.from(responseData);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getLeaveApplicationDetails({
    required int type,
    required int ref,
  }) async {
    try {
      final response = await apiService.dio.get(
        "${ApiEndPoints.getApprovalList}?APTypeID=$type&ReferenceID=$ref",
      );

      final responseData = response.data['Result'] as List;
      return responseData; // Return the list directly
    } catch (e) {
      rethrow;
    }
  }
}
