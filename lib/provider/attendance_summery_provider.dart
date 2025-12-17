import 'package:erp_solution/models/attendance_bar_chart_model.dart';
import 'package:erp_solution/models/attendance_summery_model.dart';
import 'package:erp_solution/service/attendance_summery_service.dart';
import 'package:flutter/material.dart';

class AttendanceSummeryProvider with ChangeNotifier {
  final AttendanceSummeryService service;
  AttendanceSummeryProvider(this.service);

  bool _isLoading = false;
  bool _isBarLoading = false;
  String? _error;
  String? _barError;
  AttendanceSummeryModel? _summery;
  AttendanceBarChartModel? _barChart;

  bool get isLoading => _isLoading;
  String? get error => _error;
  AttendanceSummeryModel? get summery => _summery;

  bool get isBarLoading => _isBarLoading;
  String? get barError => _barError;
  AttendanceBarChartModel? get barChart => _barChart;

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

  Future<void> loadAttendanceBarChart() async {
    _isBarLoading = true;
    _barError = null;
    notifyListeners();
    try {
      _barChart = await service.fetchAttendanceBarChart();
    } catch (e) {
      _barError = e.toString();
    } finally {
      _isBarLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    _summery = null;
    _barChart = null;
    _isLoading = false;
    _isBarLoading = false;
    _error = null;
    _barError = null;
    notifyListeners();
  }
}
