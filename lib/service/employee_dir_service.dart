import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:erp_solution/models/employee_dir_model.dart';
import 'package:erp_solution/service/api_service.dart';
import 'package:erp_solution/utils/api_end_points.dart';

class EmployeeDirService {
  final ApiService apiService;
  EmployeeDirService(this.apiService);

  Future<List<EmployeeDirModel>> fetchEmployeeDir() async {
    try {
      final response = await apiService.dio.post(
        ApiEndPoints.employeeDirectoryApi,
        data: {
          'ServerPagination': true,
          'Limit': 3000,
          'Offset': 0,
          'Order': 'asc',
          'SearchBy': '',
          'SearchType': '',
          'Search': '',
          'Sort': 'EmployeeID',
          'SortName': '',
          'SortOrder': '',
          'ApprovalFilterData': 'Active',
        },
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          responseType: ResponseType.plain, // force plain text
        ),
      );

      // unwrap "Result" directly
      final responseBody = json.decode(
        response.data,
      )['Result']['parentDataSource'];
      final List<dynamic> rows = responseBody['Rows'];
      return rows
          .map<EmployeeDirModel>((json) => EmployeeDirModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        "Fetch failed: ${e.response?.data ?? e.message ?? "Unknown error"}",
      );
    }
  }
}
