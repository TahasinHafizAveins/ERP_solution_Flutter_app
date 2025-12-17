import 'package:erp_solution/models/attendance_summery_result_model.dart';
import 'package:erp_solution/utils/color_widget.dart';
import 'package:erp_solution/utils/self_row_widget.dart';
import 'package:flutter/material.dart';

class SelfItemWidget extends StatelessWidget {
  final List<Cells> selfDetail;
  const SelfItemWidget({super.key, required this.selfDetail});

  @override
  Widget build(BuildContext context) {
    // helper to get value by id
    String getValue(String id) {
      return selfDetail
              .firstWhere(
                (cell) => cell.id == id,
                orElse: () => Cells(value: "-"),
              )
              .value ??
          "-";
    }

    final status = getValue("ATTENDANCE_STATUS");
    final date = getValue("Date");
    final day = getValue("Day");
    final dayStatus = getValue("DAY_STATUS");

    // Get status color
    final statusColor = ColorWidget.getStatusColor(status);

    // Define status icon
    IconData getStatusIcon() {
      final lowerStatus = status.toLowerCase();
      if (lowerStatus.contains("present") || lowerStatus.contains("on time")) {
        return Icons.check_circle_rounded;
      } else if (lowerStatus.contains("late")) {
        return Icons.access_time_rounded;
      } else if (lowerStatus.contains("absent")) {
        return Icons.highlight_off_rounded;
      } else if (lowerStatus.contains("leave") ||
          lowerStatus.contains("holiday")) {
        return Icons.beach_access_rounded;
      }
      return Icons.info_rounded;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          // 🔹 Header (status bar)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(getStatusIcon(), color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "$date ($day)",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Body content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Builder(
              builder: (context) {
                if (status.toLowerCase() == "holiday" ||
                    dayStatus.toLowerCase().contains("holiday")) {
                  // Show holiday reason
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.celebration_rounded,
                        color: Colors.orange.shade600,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Holiday",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dayStatus,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelfRowWidget(
                              label: "In Time",
                              value: getValue("OfficeInTime"),
                              icon: Icons.login_rounded,
                            ),
                            const SizedBox(height: 12),
                            SelfRowWidget(
                              label: "Work Hour",
                              value: getValue("WORK_HOUR"),
                              icon: Icons.timer_rounded,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 1,
                        height: 80,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelfRowWidget(
                              label: "Out Time",
                              value: getValue("OfficeOutTime"),
                              icon: Icons.logout_rounded,
                            ),
                            const SizedBox(height: 12),
                            SelfRowWidget(
                              label: "Day Status",
                              value: dayStatus,
                              icon: Icons.info_outline_rounded,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
