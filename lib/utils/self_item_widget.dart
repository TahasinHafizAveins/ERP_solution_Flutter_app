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

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          // 🔹 Header (status bar)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: ColorWidget.getStatusColor(status),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8), // match card top radius
              ),
            ),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$date ($day)",
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(width: 10),
                  Text(
                    status,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Body content
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelfRowWidget(
                        label: "In Time",
                        value: getValue("OfficeInTime"),
                      ),
                      SizedBox(height: 8),
                      SelfRowWidget(
                        label: "Work Hour",
                        value: getValue("WORK_HOUR"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelfRowWidget(
                        label: "Out Time",
                        value: getValue("OfficeOutTime"),
                      ),
                      SizedBox(height: 8),
                      SelfRowWidget(
                        label: "Day Status",
                        value: getValue("DAY_STATUS"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
