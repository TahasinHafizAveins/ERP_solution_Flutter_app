import 'package:erp_solution/models/attendance_summery_result_model.dart';
import 'package:erp_solution/utils/self_item_widget.dart';
import 'package:flutter/material.dart';

import 'attendance_summary_stats.dart';

class SelfDetails extends StatefulWidget {
  final Result? selfDetails;

  const SelfDetails({super.key, required this.selfDetails});

  @override
  State<SelfDetails> createState() => _SelfDetailsState();
}

class _SelfDetailsState extends State<SelfDetails> {
  String? _selectedFilter;

  List<Rows> _getFilteredAttendance(List<Rows> allRows) {
    if (_selectedFilter == null) return allRows;

    return allRows.where((row) {
      final status =
          row.cells
              ?.firstWhere(
                (cell) => cell.id == "ATTENDANCE_STATUS",
                orElse: () => Cells(value: "-"),
              )
              .value
              ?.toLowerCase() ??
          "-";

      switch (_selectedFilter) {
        case 'On Time':
          return status.contains("present") || status.contains("on time");
        case 'Late':
          return status.contains("late");
        case 'Absent':
          return status.contains("absent");
        case 'Leave':
          return status.contains("leave") || status.contains("holiday");
        default:
          return false;
      }
    }).toList();
  }

  void _handleFilterClick(String? status) {
    setState(() {
      _selectedFilter = _selectedFilter == status ? null : status;
    });
  }

  Widget _buildEmptyFilteredState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 60,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'No $_selectedFilter Attendance',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => _handleFilterClick(null),
              style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
              child: const Text('Show All Records'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allRows = widget.selfDetails?.table?.rows ?? [];
    final filteredRows = _getFilteredAttendance(allRows);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selfDetails?.title ?? 'Attendance',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red.shade700,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        toolbarHeight: 56,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey.shade50),
        child: Column(
          children: [
            // Compact summary
            AttendanceSummaryStats(
              selfDetails: widget.selfDetails,
              selectedFilter: _selectedFilter,
              onFilterClick: _handleFilterClick,
            ),

            // List with minimal spacing
            Expanded(
              child: filteredRows.isEmpty
                  ? _buildEmptyFilteredState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                      itemCount: filteredRows.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = filteredRows[index].cells ?? [];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SelfItemWidget(selfDetail: item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
