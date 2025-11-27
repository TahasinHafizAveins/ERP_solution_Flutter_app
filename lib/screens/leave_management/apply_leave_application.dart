import 'package:erp_solution/models/leave_balances_model.dart';
import 'package:erp_solution/provider/leave_management_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApplyLeaveApplication extends StatefulWidget {
  const ApplyLeaveApplication({super.key});

  @override
  State<ApplyLeaveApplication> createState() => _ApplyLeaveApplicationState();
}

class _ApplyLeaveApplicationState extends State<ApplyLeaveApplication> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _purposeController = TextEditingController();

  String? _selectedLeaveTypeId;
  String? _selectedBackupEmployeeId;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _stayDuringLeave;
  List<String> _attachments = [];
  List<LeaveDay> _leaveDays = [];
  bool _isLeaveDaysExpanded = false;
  bool _isLeaveBalanceExpanded = false;

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();
    DateTime nextDate = today.add(const Duration(days: 1));

    Future.microtask(() {
      final provider = Provider.of<LeaveManagementProvider>(
        context,
        listen: false,
      );
      if (provider.leaveBalances.isEmpty && !provider.isBalanceLeaveLoading) {
        provider.loadLeaveBalanceDetails(
          '0',
          getDateFormatForApi(nextDate),
          getDateFormatForApi(nextDate),
        );
      }
      if (provider.backupEmp.isEmpty && !provider.isBackupEmpLoading) {
        provider.loadBackupEmp();
      }
    });
  }

  // Helper method to get leave type name from ID
  String _getLeaveTypeName(String? leaveCategoryId) {
    if (leaveCategoryId == null) return '';
    final provider = Provider.of<LeaveManagementProvider>(
      context,
      listen: false,
    );
    try {
      final leave = provider.leaveBalances.firstWhere(
        (l) => l.leaveCategoryID?.toString() == leaveCategoryId,
      );
      return leave.systemVariableCode ?? 'Unknown';
    } catch (e) {
      return 'Unknown';
    }
  }

  // Helper method to get backup employee name from ID
  String _getBackupEmployeeName(String? employeeId) {
    if (employeeId == null) return '';
    final provider = Provider.of<LeaveManagementProvider>(
      context,
      listen: false,
    );
    try {
      final employee = provider.backupEmp.firstWhere(
        (e) => e.value?.toString() == employeeId,
      );
      return employee.label ?? 'Unknown';
    } catch (e) {
      return 'Unknown';
    }
  }

  void _showLeaveBalance() {
    final provider = Provider.of<LeaveManagementProvider>(
      context,
      listen: false,
    );

    if (provider.leaveBalances.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No leave balance data available'),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.account_balance_wallet, color: Colors.red.shade700),
            SizedBox(width: 8),
            Text('Leave Balance', style: TextStyle(color: Colors.red.shade700)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: provider.leaveBalances.map((balance) {
              return Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      balance.systemVariableCode ?? 'Unknown',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${balance.balance?.toString() ?? '0'} days',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: Colors.red.shade700)),
          ),
        ],
      ),
    );
  }

  void _generateLeaveDays() {
    if (_startDate == null || _endDate == null) return;

    _leaveDays.clear();
    DateTime current = _startDate!;

    while (current.isBefore(_endDate!) || current.isAtSameMomentAs(_endDate!)) {
      bool isNonWorkingDay = current.weekday == 5 || current.weekday == 6;

      _leaveDays.add(
        LeaveDay(
          date: current,
          isNonWorkingDay: isNonWorkingDay,
          dayType: isNonWorkingDay ? null : DayType.fullDay,
        ),
      );

      current = current.add(Duration(days: 1));
    }

    setState(() {});
  }

  void _updateDayType(int index, DayType? dayType) {
    setState(() {
      _leaveDays[index].dayType = dayType;
    });
  }

  List<Map<String, dynamic>> _getLeaveDetails() {
    return _leaveDays.where((day) => !day.isNonWorkingDay).map((day) {
      String dayStatus = 'FullDay';
      if (day.dayType == DayType.firstHalf) {
        dayStatus = 'FirstHalf';
      } else if (day.dayType == DayType.secondHalf) {
        dayStatus = 'SecondHalf';
      }

      return {
        "ELADBDID": 0,
        "Day": getDateFormatForApi(day.date),
        "DayStatus": dayStatus,
        "DayDateTime": day.date.toIso8601String(),
        "IsCancel": false,
      };
    }).toList();
  }

  List<Map<String, dynamic>> _getFilesBase64() {
    // Convert attachments to base64 format (you'll need to implement file reading)
    return _attachments.map((attachment) {
      return {
        "FileName": attachment,
        "FileContent": "", // You'll need to read and convert file to base64
        "FileType": "application/pdf", // Adjust based on actual file type
      };
    }).toList();
  }

  void _submitApplication() {
    if (_formKey.currentState!.validate()) {
      if (_selectedLeaveTypeId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select leave type'),
            backgroundColor: Colors.red.shade700,
          ),
        );
        return;
      }

      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select leave dates'),
            backgroundColor: Colors.red.shade700,
          ),
        );
        return;
      }

      if (_selectedBackupEmployeeId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select backup employee'),
            backgroundColor: Colors.red.shade700,
          ),
        );
        return;
      }

      // Prepare leave data for submission
      Map<String, dynamic> leaveData = {
        "EmployeeLeaveAID": 0,
        "RequestStartDate": getDateFormatForApi(_startDate!),
        "RequestEndDate": getDateFormatForApi(_endDate!),
        "BackupEmployeeID": int.tryParse(_selectedBackupEmployeeId ?? '0') ?? 0,
        "LeaveCategoryID": int.tryParse(_selectedLeaveTypeId ?? '0') ?? 0,
        "Purpose": _purposeController.text,
        "LeaveLocation": _stayDuringLeave ?? "",
        "DateOfJoiningWork": "",
        "ApprovalProcessID": 0,
        "LeaveDetails": _getLeaveDetails(),
        "Attachments": _getFilesBase64(),
        "IsLFA": false,
        "IsFestival": false,
        "formType": "employee",
        "EmployeeID": 0, // You'll need to get actual employee ID
        "LFADeclaration": {},
      };

      print('Leave Application Submitted:');
      print('Leave Data: $leaveData');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Leave application submitted successfully!'),
          backgroundColor: Colors.green.shade700,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Leave Application',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red.shade700,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside text fields
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.red.shade50, Colors.grey.shade50],
            ),
          ),
          child: Consumer<LeaveManagementProvider>(
            builder: (context, provider, child) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      _buildLeaveBalanceButton(),
                      const SizedBox(height: 16),
                      _buildLeaveTypeField(provider),
                      const SizedBox(height: 16),
                      _buildLeaveDatesField(),
                      const SizedBox(height: 16),
                      if (_leaveDays.isNotEmpty) ...[
                        _buildLeaveDaysList(),
                        const SizedBox(height: 16),
                      ],
                      _buildPurposeField(),
                      const SizedBox(height: 16),
                      _buildBackupEmployeeField(provider),
                      const SizedBox(height: 16),
                      _buildStayDuringLeaveField(),
                      const SizedBox(height: 16),
                      _buildAttachmentsSection(),
                      const SizedBox(height: 24),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveTypeField(LeaveManagementProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.category, color: Colors.red.shade700, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Leave Type',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                Text('*', style: TextStyle(color: Colors.red.shade700)),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedLeaveTypeId,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.red.shade700),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
              ),
              items: provider.leaveBalances.map((leave) {
                return DropdownMenuItem<String>(
                  value: leave.leaveCategoryID?.toString(),
                  child: Text(
                    leave.systemVariableCode ?? 'Unknown',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLeaveTypeId = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select leave type';
                }
                return null;
              },
              hint: Text('Select Leave Type'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveDatesField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.red.shade700,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Leave Date(s)',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                Text('*', style: TextStyle(color: Colors.red.shade700)),
              ],
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectedLeaveTypeId == null ? null : _selectDateRange,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _selectedLeaveTypeId == null
                        ? Colors.grey.shade300
                        : Colors.grey.shade400,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: _selectedLeaveTypeId == null
                      ? Colors.grey.shade100
                      : Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: _selectedLeaveTypeId == null
                          ? Colors.grey.shade400
                          : Colors.red.shade700,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _startDate == null && _endDate == null
                            ? 'Select Leave Dates'
                            : _startDate != null && _endDate != null
                            ? '${_formatDate(_startDate!)} - ${_formatDate(_endDate!)}'
                            : _startDate != null
                            ? 'From ${_formatDate(_startDate!)}'
                            : 'To ${_formatDate(_endDate!)}',
                        style: TextStyle(
                          color: _startDate == null && _endDate == null
                              ? Colors.grey.shade500
                              : Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (_startDate != null || _endDate != null)
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          size: 18,
                          color: Colors.grey.shade500,
                        ),
                        onPressed: () {
                          setState(() {
                            _startDate = null;
                            _endDate = null;
                            _leaveDays.clear();
                          });
                        },
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                  ],
                ),
              ),
            ),
            if (_startDate != null && _endDate != null) ...[
              SizedBox(height: 8),
              Text(
                'Total Days: ${_calculateTotalDays()} day${_calculateTotalDays() > 1 ? 's' : ''}',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
            if (_selectedLeaveTypeId == null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Please select leave type first',
                  style: TextStyle(color: Colors.orange.shade700, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 1),
      currentDate: DateTime.now(),
      saveText: 'SELECT',
      helpText: 'SELECT LEAVE DATES',
      confirmText: 'CONFIRM',
      cancelText: 'CANCEL',
      errorFormatText: 'Invalid format.',
      errorInvalidText: 'Invalid date range.',
      errorInvalidRangeText: 'Invalid date range.',
      fieldStartLabelText: 'Start date',
      fieldEndLabelText: 'End date',
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      initialEntryMode: DatePickerEntryMode.calendar,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _generateLeaveDays();
      });
    }
  }

  int _calculateTotalDays() {
    if (_startDate == null || _endDate == null) return 0;

    int totalDays = 0;
    DateTime current = _startDate!;

    while (current.isBefore(_endDate!) || current.isAtSameMomentAs(_endDate!)) {
      // Only count working days (exclude Fridays and Saturdays)
      if (current.weekday != 5 && current.weekday != 6) {
        totalDays++;
      }
      current = current.add(Duration(days: 1));
    }

    return totalDays;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildPurposeField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, color: Colors.red.shade700, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Leave Purpose',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                Text('*', style: TextStyle(color: Colors.red.shade700)),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _purposeController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.red.shade700),
                ),
                hintText: 'Enter purpose of leave...',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter leave purpose';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupEmployeeField(LeaveManagementProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Add this
          children: [
            Row(
              children: [
                Icon(Icons.people, color: Colors.red.shade700, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Backup Employee During Leave',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                      fontSize: 14, // Slightly smaller font
                    ),
                  ),
                ),
                Text('*', style: TextStyle(color: Colors.red.shade700)),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              // Wrap in SizedBox with fixed height
              height: 50, // Fixed height to prevent overflow
              child: DropdownButtonFormField<String>(
                value: _selectedBackupEmployeeId,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.red.shade700),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8, // Further reduced padding
                  ),
                  isDense: true,
                ),
                style: TextStyle(fontSize: 14, color: Colors.black87),
                icon: Icon(Icons.arrow_drop_down, size: 20),
                items: provider.backupEmp.map((emp) {
                  return DropdownMenuItem<String>(
                    value: emp.value?.toString(),
                    child: Text(
                      emp.label ?? 'Unknown',
                      style: TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBackupEmployeeId = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select backup employee';
                  }
                  return null;
                },
                hint: Text(
                  'Select Backup Employee',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStayDuringLeaveField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red.shade700, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Stay During Leave',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              onChanged: (value) => _stayDuringLeave = value,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.red.shade700),
                ),
                hintText: 'Enter your location during leave (optional)...',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.attach_file, color: Colors.red.shade700, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Attachments',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_attachments.isNotEmpty)
              ..._attachments.map((attachment) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.insert_drive_file, color: Colors.red.shade700),
                      SizedBox(width: 8),
                      Expanded(child: Text(attachment)),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red.shade400),
                        onPressed: () {
                          setState(() {
                            _attachments.remove(attachment);
                          });
                        },
                      ),
                    ],
                  ),
                );
              }),
            ElevatedButton.icon(
              onPressed: _addAttachment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red.shade700,
                side: BorderSide(color: Colors.red.shade700),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: Icon(Icons.add),
              label: Text('Add Attachment'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveBalanceButton() {
    // Get specific leave types for summary
    final annualLeave = _getLeaveBalanceByType('Annual Leave');
    final sickLeave = _getLeaveBalanceByType('Sick Leave');
    final casualLeave = _getLeaveBalanceByType('Casual Leave');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: Colors.red.shade700,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Leave Balance',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Summary Section (Only three types)
            _buildLeaveBalanceSummary(annualLeave, sickLeave, casualLeave),

            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showLeaveBalanceDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Icon(Icons.list_alt, size: 18),
                label: Text('View All Leave Balance Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveBalanceSummary(
    LeaveBalances? annual,
    LeaveBalances? sick,
    LeaveBalances? casual,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Annual Leave
          Expanded(
            child: _buildSummaryItem(
              'Annual',
              annual?.balance ?? 0,
              Colors.blue.shade700,
              Icons.beach_access,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
            margin: EdgeInsets.symmetric(horizontal: 8),
          ),
          // Sick Leave
          Expanded(
            child: _buildSummaryItem(
              'Sick',
              sick?.balance ?? 0,
              Colors.green.shade700,
              Icons.medical_services,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
            margin: EdgeInsets.symmetric(horizontal: 8),
          ),
          // Casual Leave
          Expanded(
            child: _buildSummaryItem(
              'Casual',
              casual?.balance ?? 0,
              Colors.orange.shade700,
              Icons.emoji_emotions,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String title,
    double balance,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          balance.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          'days left',
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  void _showLeaveBalanceDetails() {
    final provider = Provider.of<LeaveManagementProvider>(
      context,
      listen: false,
    );

    if (provider.leaveBalances.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No leave balance data available'),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight:
                MediaQuery.of(context).size.height *
                0.8, // 80% of screen height
          ),
          child: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header (fixed)
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: Colors.red.shade700,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Leave Balance Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.grey.shade500),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // All leave types in details
                        ...provider.leaveBalances.map((balance) {
                          return _buildLeaveTypeDetailCard(balance);
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveTypeDetailCard(LeaveBalances balance) {
    // Determine color based on leave type
    Color getColor() {
      final type = balance.systemVariableCode?.toLowerCase() ?? '';

      if (type.contains('annual')) return Colors.blue.shade700;
      if (type.contains('sick')) return Colors.green.shade700;
      if (type.contains('casual')) return Colors.orange.shade700;
      if (type.contains('compensatory')) return Colors.teal.shade700;
      if (type.contains('pilgrim')) return Colors.brown.shade600;
      if (type.contains('transit')) return Colors.cyan.shade600;
      if (type.contains('special')) return Colors.indigo.shade600;
      if (type.contains('maternity')) return Colors.pink.shade600;
      if (type.contains('paternity')) return Colors.lightBlue.shade600;

      return Colors.purple.shade700;
    }

    final color = getColor();

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with leave type and remaining balance
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  balance.systemVariableCode ?? 'Unknown Leave Type',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Text(
                  '${balance.balance?.toStringAsFixed(1) ?? '0'} days left',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Details in two columns
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      'CF From Previous Year',
                      balance.previousLeaveDays ?? 0,
                    ),
                    _buildDetailRow('Allocated', balance.leaveDays ?? 0),
                    _buildDetailRow(
                      'Approved',
                      balance.noOfApprovedLeaveDays ?? 0,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      'Pending',
                      balance.noOfPendingLeaveDays ?? 0,
                    ),
                    _buildDetailRow('Applying', balance.applying ?? 0),
                    _buildDetailRow(
                      'Remaining',
                      balance.balance ?? 0,
                      isHighlighted: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    double value, {
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isHighlighted
                    ? Colors.green.shade700
                    : Colors.grey.shade800,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveTypeDetails(
    String title,
    LeaveBalances balance,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),

          // Details in two columns
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      'CF From Previous Year',
                      balance.previousLeaveDays ?? 0,
                    ),
                    _buildDetailRow('Allocated', balance.leaveDays ?? 0),
                    _buildDetailRow(
                      'Approved',
                      balance.noOfApprovedLeaveDays ?? 0,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      'Pending',
                      balance.noOfPendingLeaveDays ?? 0,
                    ),
                    _buildDetailRow('Applying', balance.applying ?? 0),
                    _buildDetailRow('Remaining', balance.balance ?? 0),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to get specific leave type
  LeaveBalances? _getLeaveBalanceByType(String type) {
    final provider = Provider.of<LeaveManagementProvider>(
      context,
      listen: false,
    );
    try {
      return provider.leaveBalances.firstWhere(
        (balance) =>
            balance.systemVariableCode?.toLowerCase().contains(
              type.toLowerCase(),
            ) ??
            false,
      );
    } catch (e) {
      return null;
    }
  }

  Widget _buildLeaveDaysList() {
    final workingDays = _leaveDays
        .where((day) => !day.isNonWorkingDay)
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with toggle
            InkWell(
              onTap: () {
                setState(() {
                  _isLeaveDaysExpanded = !_isLeaveDaysExpanded;
                });
              },
              child: Row(
                children: [
                  Icon(
                    _isLeaveDaysExpanded
                        ? Icons.unfold_less
                        : Icons.unfold_more,
                    color: Colors.red.shade700,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Leave Days Breakdown',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      '${workingDays.length} working day${workingDays.length != 1 ? 's' : ''}',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    backgroundColor: Colors.red.shade700,
                  ),
                ],
              ),
            ),

            // Expanded content
            if (_isLeaveDaysExpanded) ...[
              const SizedBox(height: 16),
              ...workingDays.asMap().entries.map((entry) {
                final index = entry.key;
                final day = entry.value;

                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${_formatDate(day.date)} (${_getDayName(day.date.weekday)})',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.shade300),
                            ),
                            child: Text(
                              _getDayTypeLabel(day.dayType),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      _buildDayTypeSelector(index, day),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  String _getDayTypeLabel(DayType? dayType) {
    switch (dayType) {
      case DayType.fullDay:
        return 'Full Day';
      case DayType.firstHalf:
        return 'First Half';
      case DayType.secondHalf:
        return 'Second Half';
      default:
        return 'Not Selected';
    }
  }

  Widget _buildDayTypeSelector(int index, LeaveDay day) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildDayTypeChip(
          index,
          DayType.fullDay,
          'Full Day',
          day.dayType == DayType.fullDay,
        ),
        _buildDayTypeChip(
          index,
          DayType.firstHalf,
          'First Half',
          day.dayType == DayType.firstHalf,
        ),
        _buildDayTypeChip(
          index,
          DayType.secondHalf,
          'Second Half',
          day.dayType == DayType.secondHalf,
        ),
      ],
    );
  }

  Widget _buildDayTypeChip(
    int index,
    DayType type,
    String label,
    bool isSelected,
  ) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        _updateDayType(index, selected ? type : null);
      },
      selectedColor: Colors.red.shade700,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontSize: 12,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitApplication,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade700,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Text(
          'Submit Leave Application',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000), // Allow past dates
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
        _generateLeaveDays();
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? (_startDate ?? DateTime.now()),
      firstDate: _startDate ?? DateTime(2000), // Allow past dates
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
        _generateLeaveDays();
      });
    }
  }

  void _addAttachment() {
    setState(() {
      _attachments.add('Document_${_attachments.length + 1}.pdf');
    });
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String getDateFormatForApi(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }
}

enum DayType { fullDay, firstHalf, secondHalf }

class LeaveDay {
  final DateTime date;
  final bool isNonWorkingDay;
  DayType? dayType;

  LeaveDay({required this.date, required this.isNonWorkingDay, this.dayType});

  @override
  String toString() {
    return 'LeaveDay{date: $date, isNonWorkingDay: $isNonWorkingDay, dayType: $dayType}';
  }
}
