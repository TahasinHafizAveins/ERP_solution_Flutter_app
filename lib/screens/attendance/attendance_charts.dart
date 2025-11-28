import 'package:erp_solution/models/attendance_bar_chart_model.dart';
import 'package:erp_solution/models/attendance_summery_result_model.dart';
import 'package:erp_solution/screens/attendance/bar_chart_attendance.dart';
import 'package:erp_solution/screens/attendance/pie_chart_attendance.dart';
import 'package:flutter/material.dart';

class AttendanceCharts extends StatefulWidget {
  final String selectedDuration;
  final Result? attendanceResult;
  final AttendanceBarChartModel? attendanceBarChartModel;

  const AttendanceCharts({
    super.key,
    required this.selectedDuration,
    required this.attendanceResult,
    required this.attendanceBarChartModel,
  });

  @override
  State<AttendanceCharts> createState() => _AttendanceChartsState();
}

class _AttendanceChartsState extends State<AttendanceCharts> {
  int? touchedIndex;
  int _selectedChartIndex = 0; // 0 for Pie, 1 for Bar

  @override
  Widget build(BuildContext context) {
    var scWidth = MediaQuery.of(context).size.height;

    if (widget.attendanceResult == null &&
        widget.attendanceBarChartModel == null) {
      return const Center(child: Text("No data available"));
    }

    // Determine which charts are available
    final hasPieChart = widget.attendanceResult != null;
    final hasBarChart = widget.attendanceBarChartModel != null;

    // If only one chart is available, force that chart
    if (hasPieChart && !hasBarChart) {
      _selectedChartIndex = 0;
    } else if (!hasPieChart && hasBarChart) {
      _selectedChartIndex = 1;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(2.0, 10, 2, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Only show toggle if both charts are available
              if (hasPieChart && hasBarChart) _buildChartToggle(),
              const SizedBox(height: 10),

              // Show the selected chart
              if (_selectedChartIndex == 0 && hasPieChart)
                PieChartAttendance(
                  selectedDuration: widget.selectedDuration,
                  attendanceResult: widget.attendanceResult,
                  attendanceBarChartModel: widget.attendanceBarChartModel,
                  scWidth: scWidth,
                )
              else if (_selectedChartIndex == 1 && hasBarChart)
                BarChartAttendance(
                  selectedDuration: widget.selectedDuration,
                  attendanceResult: widget.attendanceResult,
                  attendanceBarChartModel: widget.attendanceBarChartModel,
                )
              else
                const Center(child: Text("Chart data not available")),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          // Pie Chart Button
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedChartIndex = 0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: _selectedChartIndex == 0
                      ? Colors.brown[700]
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  'Summary',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _selectedChartIndex == 0
                        ? Colors.white
                        : Colors.grey[700],
                  ),
                ),
              ),
            ),
          ),

          // Bar Chart Button
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedChartIndex = 1),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: _selectedChartIndex == 1
                      ? Colors.brown[700]
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  'Time Analysis',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _selectedChartIndex == 1
                        ? Colors.white
                        : Colors.grey[700],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
