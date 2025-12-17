import 'package:erp_solution/models/attendance_summery_result_model.dart';
import 'package:flutter/material.dart';

class AttendanceSummaryStats extends StatelessWidget {
  final Result? selfDetails;
  final String? selectedFilter;
  final Function(String?) onFilterClick;

  const AttendanceSummaryStats({
    super.key,
    required this.selfDetails,
    required this.selectedFilter,
    required this.onFilterClick,
  });

  @override
  Widget build(BuildContext context) {
    final rows = selfDetails?.table?.rows ?? [];

    // Calculate statistics
    int total = rows.length;
    int present = 0;
    int late = 0;
    int absent = 0;
    int leave = 0;

    for (final row in rows) {
      final status =
          row.cells
              ?.firstWhere(
                (cell) => cell.id == "ATTENDANCE_STATUS",
                orElse: () => Cells(value: "-"),
              )
              .value
              ?.toLowerCase() ??
          "-";

      if (status.contains("present") || status.contains("on time")) {
        present++;
      } else if (status.contains("late")) {
        late++;
      } else if (status.contains("absent")) {
        absent++;
      } else if (status.contains("leave") || status.contains("holiday")) {
        leave++;
      }
    }

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade600, Colors.red.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade300.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Compact header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    size: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    selectedFilter == null
                        ? 'Attendance'
                        : 'Filter: $selectedFilter',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (selectedFilter != null)
                GestureDetector(
                  onTap: () => onFilterClick(null),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.clear, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Compact stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCompactStatItem(
                'Total',
                total.toString(),
                Icons.calendar_view_day_rounded,
                isSelected: selectedFilter == null,
                onTap: () => onFilterClick(null),
              ),
              _buildCompactStatItem(
                'On Time',
                present.toString(),
                Icons.check_circle_outline_rounded,
                isSelected: selectedFilter == 'On Time',
                onTap: () => onFilterClick('On Time'),
              ),
              _buildCompactStatItem(
                'Late',
                late.toString(),
                Icons.access_time_rounded,
                isSelected: selectedFilter == 'Late',
                onTap: () => onFilterClick('Late'),
              ),
              _buildCompactStatItem(
                'Absent',
                absent.toString(),
                Icons.highlight_off_rounded,
                isSelected: selectedFilter == 'Absent',
                onTap: () => onFilterClick('Absent'),
              ),
              _buildCompactStatItem(
                'Leave',
                leave.toString(),
                Icons.beach_access_rounded,
                isSelected: selectedFilter == 'Leave',
                onTap: () => onFilterClick('Leave'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatItem(
    String title,
    String value,
    IconData icon, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.red.shade700 : Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
