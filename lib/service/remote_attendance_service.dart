import 'package:erp_solution/models/country_model.dart';
import 'package:erp_solution/models/remote_attendance_model.dart';
import 'package:erp_solution/service/api_service.dart';
import 'package:erp_solution/utils/api_end_points.dart';

class RemoteAttendanceService {
  final ApiService apiService;
  RemoteAttendanceService(this.apiService);

  Future<List<CountryModel>> getCountryDivision() async {
    List<CountryModel> countryList = [];

    try {
      final response = await apiService.dio.get(
        ApiEndPoints.divisionOfCountryApi,
      );

      final List<dynamic> responseBody = response.data['Result'];
      countryList = responseBody
          .map<CountryModel>((json) => CountryModel.fromJson(json))
          .toList();
      return countryList;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CountryModel>> getDistrictsByDivision({
    required String divisionId,
  }) async {
    List<CountryModel> districtList = [];

    try {
      final response = await apiService.dio.get(
        '${ApiEndPoints.districtsByDivisionApi}/$divisionId',
      );

      final List<dynamic> responseBody = response.data['Result'];
      districtList = responseBody
          .map<CountryModel>((json) => CountryModel.fromJson(json))
          .toList();
      return districtList;
    } catch (e) {
      return districtList;
    }
  }

  Future<List<CountryModel>> getThanaByDistrict({
    required String districtId,
  }) async {
    List<CountryModel> thanaList = [];

    try {
      final response = await apiService.dio.get(
        '${ApiEndPoints.thanaByDistrictApi}/$districtId',
      );

      final List<dynamic> responseBody = response.data['Result'];
      thanaList = responseBody
          .map<CountryModel>((json) => CountryModel.fromJson(json))
          .toList();
      return thanaList;
    } catch (e) {
      return thanaList;
    }
  }

  Future<RemoteAttendanceModel> getRemoteAttendanceList() async {
    RemoteAttendanceModel remoteAttendanceModel = RemoteAttendanceModel();

    try {
      final response = await apiService.dio.get(
        ApiEndPoints.remoteAttendanceListApi,
      );

      remoteAttendanceModel = RemoteAttendanceModel.fromJson(response.data);
      return remoteAttendanceModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> submitRemoteAttendance({
    required AttendanceModel attendanceModel,
  }) async {
    try {
      final body = {
        'EmployeeNote': attendanceModel.employeeNote,
        'DistrictID': attendanceModel.districtID,
        'DivisionID': attendanceModel.divisionID,
        'ThanaID': attendanceModel.thanaID,
        'Area': attendanceModel.area,
        'Latitude': double.tryParse(attendanceModel.latitude ?? '0'),
        'Longitude': double.tryParse(attendanceModel.longitude ?? '0'),
        'EntryType': attendanceModel.entryType,
      };

      final response = await apiService.dio.post(
        ApiEndPoints.remoteAttendanceSubmitApi,
        data: body,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to submit remote attendance');
      }
      // You can handle the response if needed
    } catch (e) {
      rethrow;
    }
  }
}
