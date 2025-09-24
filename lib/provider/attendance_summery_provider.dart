import 'package:erp_solution/models/attendance_summery_model.dart';
import 'package:erp_solution/service/attendance_summery_service.dart';
import 'package:flutter/material.dart';

class AttendanceSummeryProvider with ChangeNotifier {
  final AttendanceSummeryService service;
  AttendanceSummeryProvider(this.service);

  bool _isLoading = false;
  String? _error;
  AttendanceSummeryModel? _summery;

  bool get isLoading => _isLoading;
  String? get error => _error;
  AttendanceSummeryModel? get summery => _summery;

  Future<void> loadAttendanceSummery() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _summery = await service.fetchAttendanceSummary();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
