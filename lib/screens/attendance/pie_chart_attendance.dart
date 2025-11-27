import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/attendance_bar_chart_model.dart';
import '../../models/attendance_summery_result_model.dart';

class PieChartAttendance extends StatefulWidget {
  final String selectedDuration;
  final Result? attendanceResult;
  final AttendanceBarChartModel? attendanceBarChartModel;
  final double scWidth;
  const PieChartAttendance({
    super.key,
    required this.selectedDuration,
    required this.attendanceResult,
    required this.attendanceBarChartModel,
    required this.scWidth,
  });

  @override
  State<PieChartAttendance> createState() => _PieChartAttendanceState();
}

class _PieChartAttendanceState extends State<PieChartAttendance> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    final dataset = widget
        .attendanceResult
        ?.mainChart
        ?.datasets?[widget.selectedDuration]?[0];

    final labels = widget.attendanceResult?.mainChart?.labels ?? [];
    final colors = dataset?.backgroundColor ?? [];
    final values = dataset?.data ?? [];

    return Column(
      children: [
        Center(
          child: Text(
            "${widget.attendanceResult?.title} - ${widget.attendanceResult?.ranges?[widget.selectedDuration] ?? ''}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.brown[900],
            ),
          ),
        ),

        //const SizedBox(height: 5),
        _buildLegend(labels, colors),

        // const SizedBox(height: 5),
        AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    } else {
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    }
                  });
                },
              ),
              startDegreeOffset: 180,
              borderData: FlBorderData(show: false),
              centerSpaceRadius: widget.scWidth / 12,
              sectionsSpace: 1,
              sections: List.generate(values.length, (i) {
                final value = values[i].toDouble();
                final sectionValue = value == 0 ? 0.001 : value;
                final isTouched = i == touchedIndex;
                final radius = isTouched
                    ? widget.scWidth / 10
                    : widget.scWidth / 11;
                final sectionTitle = "${value.toInt()}\n${labels[i]}";

                return PieChartSectionData(
                  value: value,
                  color: _getSectionColor(colors[i], isTouched),
                  radius: radius,
                  title: isTouched ? sectionTitle : "",
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).whereType<PieChartSectionData>().toList(),
            ),
          ),
        ),

        // const SizedBox(height: 2),
        _buildPieChartFooter(),
      ],
    );
  }

  Widget _buildLegend(List<String> labels, List<String> colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 1,
          children: List.generate(labels.length, (i) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 4),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _hexToColor(colors[i]),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  labels[i],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Color _getSectionColor(String hex, bool isTouched) {
    final baseColor = _hexToColor(hex);
    if (!isTouched) return baseColor;
    return baseColor.withOpacity(0.7);
  }

  Widget _buildPieChartFooter() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:
            widget.attendanceResult?.footer?.map((footerItem) {
              String count = "0";
              if (widget.selectedDuration == "LW") {
                count = footerItem.count?.lW ?? "0";
              } else if (widget.selectedDuration == "L2W") {
                count = footerItem.count?.l2W ?? "0";
              } else if (widget.selectedDuration == "L1M") {
                count = footerItem.count?.l1M ?? "0";
              }

              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      count,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      footerItem.title ?? "",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }).toList() ??
            [],
      ),
    );
  }
}
