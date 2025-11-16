import 'package:erp_solution/models/country_model.dart';
import 'package:erp_solution/models/remote_attendance_model.dart';
import 'package:erp_solution/service/remote_attendance_service.dart';
import 'package:flutter/material.dart';

class RemoteAttendanceProvider with ChangeNotifier {
  final RemoteAttendanceService service;
  RemoteAttendanceProvider(this.service);

  bool _isLoading = false;

  String? _error;
  List<CountryModel> _divisions = [];
  List<CountryModel> _districts = [];
  List<CountryModel> _thana = [];
  RemoteAttendanceModel? _remoteAttendance;

  CountryModel? selectedDivision;
  CountryModel? selectedDistrict;
  CountryModel? selectedThana;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<CountryModel> get divisions => _divisions;
  List<CountryModel> get districts => _districts;
  List<CountryModel> get thana => _thana;
  RemoteAttendanceModel? get remoteAttendance => _remoteAttendance;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// fetch all division
  Future<void> fetchDivisions() async {
    _setLoading(true);
    _error = null;
    try {
      _divisions = await service.getCountryDivision();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// fetch districts by division id
  Future<void> fetchDistricts(String divisionId) async {
    _setLoading(true);
    _error = null;
    try {
      _districts = await service.getDistrictsByDivision(divisionId: divisionId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// fetch thana by district id
  Future<void> fetchThana(String districtId) async {
    _setLoading(true);
    _error = null;
    try {
      _thana = await service.getThanaByDistrict(districtId: districtId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// fetch remote attendance list
  Future<void> fetchRemoteAttendanceList() async {
    _setLoading(true);
    _error = null;
    try {
      _remoteAttendance = await service.getRemoteAttendanceList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  ///selected section
  void selectDivision(CountryModel division) {
    selectedDivision = division;
    selectedDistrict = null;
    selectedThana = null;
    _districts = [];
    _thana = [];
    notifyListeners();
    fetchDistricts(division.value.toString() ?? '');
  }

  void selectDistrict(CountryModel district) {
    selectedDistrict = district;
    selectedThana = null;
    _thana = [];
    notifyListeners();
    fetchThana(district.value.toString() ?? '');
  }

  void selectThana(CountryModel thana) {
    selectedThana = thana;
    notifyListeners();
  }

  void clearSelections() {
    selectedDivision = null;
    selectedDistrict = null;
    selectedThana = null;
    notifyListeners();
  }

  ///submit remote attendance

  Future<bool> submitRemoteAttendance(AttendanceModel attendanceModel) async {
    _setLoading(true);
    _error = null;
    try {
      await service.submitRemoteAttendance(attendanceModel: attendanceModel);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void reset() {
    _error = null;
    _divisions = [];
    _districts = [];
    _thana = [];
    _remoteAttendance = null;
    notifyListeners();
  }
}
