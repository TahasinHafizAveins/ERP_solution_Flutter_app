import 'package:erp_solution/models/remote_attendance_model.dart';
import 'package:erp_solution/provider/remote_attendance_provider.dart';
import 'package:erp_solution/screens/remote_attendance/area_text_field.dart';
import 'package:erp_solution/screens/remote_attendance/attendance_header_card.dart';
import 'package:erp_solution/screens/remote_attendance/location_card.dart';
import 'package:erp_solution/screens/remote_attendance/manual_location_selector.dart';
import 'package:erp_solution/screens/remote_attendance/note_text_field.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../home.dart';

class RemoteAttendance extends StatefulWidget {
  const RemoteAttendance({super.key});

  @override
  State<RemoteAttendance> createState() => _RemoteAttendanceState();
}

class _RemoteAttendanceState extends State<RemoteAttendance> {
  // Controllers
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final formattedDate =
      "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
  double? _latitude;
  double? _longitude;
  bool _isCheckedIn = false;
  bool _isLocating = false;
  DateTime? _checkInTime;
  DateTime? _checkOutTime;

  final Color _primaryRed = const Color(0xFFD32F2F);

  //call api for division
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final provider = Provider.of<RemoteAttendanceProvider>(
        context,
        listen: false,
      );
      provider.fetchDivisions();
      provider.fetchRemoteAttendanceList();
    });
  }

  @override
  void dispose() {
    _areaController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // 🔹 Get location
  Future<void> _getCurrentLocation() async {
    setState(() => _isLocating = true);
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showMsg('Enable location services', isError: true);
      setState(() => _isLocating = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showMsg('Location permission denied', isError: true);
        setState(() => _isLocating = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showMsg(
        'Permission permanently denied. Enable from settings.',
        isError: true,
      );
      setState(() => _isLocating = false);
      return;
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _latitude = pos.latitude;
        _longitude = pos.longitude;
      });
      _showMsg('📍 Location captured successfully');
    } catch (e) {
      _showMsg('Failed to get location', isError: true);
    } finally {
      setState(() => _isLocating = false);
    }
  }

  void _clearLocation() {
    setState(() {
      _latitude = null;
      _longitude = null;
    });
    _showMsg('📍 Location cleared');
  }

  void _showMsg(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.black87 : _primaryRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // 🔹 Check In / Out
  Future<void> _onCheckIn({required RemoteAttendanceProvider provider}) async {
    if (_latitude == null || _longitude == null) {
      _showMsg('Get your location before check-in', isError: true);
      return;
    }

    if (provider.selectedDivision == null ||
        provider.selectedDistrict == null ||
        provider.selectedThana == null) {
      _showMsg('Select Division, District and Thana', isError: true);
      return;
    }

    final attendanceModel = AttendanceModel(
      employeeNote: _noteController.text,
      divisionID: provider.selectedDivision!.value,
      districtID: provider.selectedDistrict!.value,
      thanaID: provider.selectedThana!.value,
      area: _areaController.text,
      latitude: _latitude.toString(),
      longitude: _longitude.toString(),
      entryType: 'IN',
    );

    final success = await provider.submitRemoteAttendance(attendanceModel);

    if (success) {
      setState(() {
        _isCheckedIn = true;
        _checkInTime = DateTime.now();
        // Clear UI fields
        _areaController.clear();
        _noteController.clear();
        _latitude = null;
        _longitude = null;
      });
      // Clear dropdown selections
      provider.clearSelections();
      _showMsg('✅ Checked in successfully');
    } else {
      _showMsg('Check-in failed', isError: true);
    }
  }

  Future<void> _onCheckOut({required RemoteAttendanceProvider provider}) async {
    if (_latitude == null || _longitude == null) {
      _showMsg('Get your location before check-in', isError: true);
      return;
    }

    if (provider.selectedDivision == null ||
        provider.selectedDistrict == null ||
        provider.selectedThana == null) {
      _showMsg('Select Division, District and Thana', isError: true);
      return;
    }

    final attendanceModel = AttendanceModel(
      employeeNote: _noteController.text,
      divisionID: provider.selectedDivision!.value,
      districtID: provider.selectedDistrict!.value,
      thanaID: provider.selectedThana!.value,
      area: _areaController.text,
      latitude: _latitude.toString(),
      longitude: _longitude.toString(),
      entryType: 'OUT',
    );

    final success = await provider.submitRemoteAttendance(attendanceModel);
    if (success) {
      setState(() {
        _isCheckedIn = false;
        _checkOutTime = DateTime.now();
        //  Clear UI fields
        _areaController.clear();
        _noteController.clear();
        _latitude = null;
        _longitude = null;
      });
      //  Clear dropdown selections
      provider.clearSelections();

      _showMsg('👋 Checked out successfully');
    } else {
      _showMsg('Check-out failed', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RemoteAttendanceProvider>(
      builder: (context, provider, _) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: const Color(0xFFF9F9F9),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: _primaryRed),
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (route) => false,
                ),
              ),
              title: Text(
                "Remote Attendance",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _primaryRed,
                  fontSize: 18,
                ),
              ),
              bottom: TabBar(
                labelColor: _primaryRed,
                unselectedLabelColor: Colors.grey,
                indicatorColor: _primaryRed,
                tabs: const [
                  Tab(text: 'Check In/Out'),
                  Tab(text: 'History'),
                ],
              ),
            ),

            body: TabBarView(
              children: [
                _buildCheckInOutView(provider),
                _buildRemoteHistoryView(provider),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildCheckInOutView(RemoteAttendanceProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔸 Header card (keep old look, just color tweak)
          AttendanceHeaderCard(
            formattedDate: formattedDate,
            isCheckedIn: _isCheckedIn,
            checkInTime: _checkInTime,
          ),

          const SizedBox(height: 20),

          // 🔹 Current Location Card
          LocationCard(
            onGetLocation: _getCurrentLocation,
            onClearLocation: _clearLocation,
            latitude: _latitude,
            longitude: _longitude,
            isLocating: _isLocating,
          ),
          const SizedBox(height: 20),

          // 🔹 Placeholder for manual location etc.
          ManualLocationSelector(),
          const SizedBox(height: 16),
          AreaTextField(controller: _areaController),
          const SizedBox(height: 16),
          NoteTextField(controller: _noteController),

          const SizedBox(height: 30),

          // 🔹 Premium Check-In / Check-Out Buttons
          Consumer<RemoteAttendanceProvider>(
            builder: (context, provider, _) {
              return Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _onCheckIn(provider: provider),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_primaryRed, Colors.redAccent.shade100],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: _primaryRed.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Text(
                          "Check In",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _onCheckOut(provider: provider),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: _primaryRed, width: 1.2),
                        ),
                        child: Text(
                          "Check Out",
                          style: TextStyle(
                            color: _primaryRed,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  _buildRemoteHistoryView(RemoteAttendanceProvider provider) {
    final redColor = Colors.redAccent.shade400;
    List<AttendanceModel> attendanceList =
        provider.remoteAttendance?.result?.attendanceList ?? [];

    // Dummy check for when data is loading or empty
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (attendanceList.isEmpty) {
      return const Center(
        child: Text(
          "No previous attendance records found.",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: attendanceList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = attendanceList[index];

        // Highlight color for status
        final isApproved = item.statusName?.toLowerCase() == "approved";
        final isPending = item.statusName?.toLowerCase() == "pending";
        final isRejected = item.statusName?.toLowerCase() == "rejected";

        Color statusColor;
        if (isApproved) {
          statusColor = Colors.green.shade600;
        } else if (isRejected) {
          statusColor = Colors.redAccent.shade400;
        } else {
          statusColor = Colors.orange.shade600;
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Status
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.statusName ?? "Unknown",
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    getDateString(item),
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // 🔸 Approver
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.approverName ?? "N/A",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // 📝 Approver Note
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.sticky_note_2_outlined,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.approverNote?.isNotEmpty == true
                          ? item.approverNote!
                          : "No note provided",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  formattedApiDate(String? approvalDate, String? dateType) {
    if (approvalDate == null || approvalDate.isEmpty) return null;
    try {
      // Parse the string into DateTime
      DateTime dateTime = DateTime.parse(approvalDate);

      // Format to DD-MMM-YYYY hh:mm a
      String formatted = DateFormat('dd-MMM-yyyy hh:mm a').format(dateTime);
      return "$dateType : $formatted";
    } catch (e) {
      return null;
    }
  }

  String getDateString(AttendanceModel item) {
    if (item.statusName == 'Approved') {
      return formattedApiDate(item.approvalDate, "Approved On") ?? "";
    } else if (item.statusName == 'Pending') {
      return formattedApiDate(item.attendanceDate, "Submitted On") ?? "";
    } else if (item.statusName == 'Rejected') {
      return formattedApiDate(item.approvalDate, "Rejected On") ?? "";
    } else {
      return "Date N/A";
    }
  }
}
