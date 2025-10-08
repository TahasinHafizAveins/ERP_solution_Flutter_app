import 'package:erp_solution/models/employee_dir_model.dart';
import 'package:erp_solution/service/employee_dir_service.dart';
import 'package:flutter/material.dart';

class EmployeeDirProvider with ChangeNotifier {
  final EmployeeDirService service;

  EmployeeDirProvider(this.service);

  bool _isLoading = false;
  String? _error;
  List<EmployeeDirModel> employeesDir = [];

  bool get isLoading => _isLoading;

  String? get error => _error;

  List<EmployeeDirModel> get employees => employeesDir;

  Future<void> loadEmployeeDir() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      employeesDir = await service.fetchEmployeeDir();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
