import 'package:erp_solution/models/attendance_summery_model.dart';
import 'package:erp_solution/service/team_mem_attendance_details_service.dart';
import 'package:flutter/material.dart';

class TeamMemAttendanceDetailsProvider with ChangeNotifier {
  final TeamMemAttendanceDetailsService service;

  TeamMemAttendanceDetailsProvider(this.service);

  bool _isLoading = false;
  String? _error;
  AttendanceSummeryModel? _summery;

  bool get isLoading => _isLoading;
  String? get error => _error;
  AttendanceSummeryModel? get summery => _summery;

  Future<void> loadTeamAttendanceDetails(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _summery = await service.fetchAttendanceSummary(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
