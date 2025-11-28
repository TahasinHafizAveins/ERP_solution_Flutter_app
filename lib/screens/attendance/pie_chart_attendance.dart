import 'dart:math';

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
  static const List<String> _fixedLabels = [
    'On Time',
    'Late',
    'Absent',
    'Leave',
    'Holiday & Weekend',
    'Partial Entry',
  ];

  static const List<Color> _fixedColors = [
    Color(0xFF2ECC71),
    Color(0xFFFFA726),
    Color(0xFFEF5350),
    Color(0xFF42A5F5),
    Color(0xFF9C27B0),
    Color(0xFF26A69A),
  ];

  @override
  Widget build(BuildContext context) {
    return _buildArcChartContent();
  }

  Widget _buildArcChartContent() {
    final dataset = widget
        .attendanceResult
        ?.mainChart
        ?.datasets?[widget.selectedDuration]?[0];

    final apiLabels = widget.attendanceResult?.mainChart?.labels ?? <String>[];
    final rawValues = dataset?.data ?? <dynamic>[];

    final Map<String, double> apiMap = {};
    for (int i = 0; i < apiLabels.length; i++) {
      final key = apiLabels[i] ?? '';
      final dynamic raw = (i < rawValues.length) ? rawValues[i] : 0;
      apiMap[key] = _toDoubleSafe(raw);
    }

    final List<double> counts = List<double>.generate(_fixedLabels.length, (i) {
      final String target = _fixedLabels[i].toLowerCase();
      final List<String> keywords = _keywordsForIndex(i);

      for (final apiLabel in apiMap.keys) {
        final apiLower = apiLabel.toLowerCase();
        for (final kw in keywords) {
          if (apiLower.contains(kw)) {
            return apiMap[apiLabel]!;
          }
        }
      }

      for (final apiLabel in apiMap.keys) {
        if (apiLabel.toLowerCase() == target) return apiMap[apiLabel]!;
      }

      return 0.0;
    });

    return Column(
      children: [
        // -------- ARC CHART --------
        Center(
          child: SizedBox(
            width: widget.scWidth,
            height: widget.scWidth * 0.45, // FIXED for 80% gauge visibility
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  painter: _StackedArcPainter(
                    counts: counts,
                    colors: _fixedColors,
                    strokeWidth: widget.scWidth * 0.09 / 10,
                    gap: widget.scWidth * 0.009,
                  ),
                  size: Size(widget.scWidth, widget.scWidth * 0.9),
                ),

                /// TEXT INSIDE THE 80% CIRCLE
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      _centerSubtitle(widget.selectedDuration),
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // -------- LEGEND --------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: List.generate(_fixedLabels.length, (i) {
              final label = _fixedLabels[i];
              final color = _fixedColors[i];
              final value = counts[i].toInt();
              final displayCount = value.toString().padLeft(2, '0');

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "$displayCount $label",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  double _toDoubleSafe(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v.replaceAll(',', '')) ?? 0.0;
    if (v is num) return v.toDouble();
    return 0.0;
  }

  static List<String> _keywordsForIndex(int idx) {
    switch (idx) {
      case 0:
        return ['on time', 'ontime', 'on-time', 'on_time', 'present'];
      case 1:
        return ['late', 'delay'];
      case 2:
        return ['absent', 'abs'];
      case 3:
        return ['leave', 'leaves'];
      case 4:
        return ['holiday', 'weekend'];
      case 5:
        return ['partial', 'partial entry'];
      default:
        return [];
    }
  }

  static String _centerSubtitle(String selectedDuration) {
    switch (selectedDuration) {
      case 'LW':
        return 'Last Week';
      case 'L2W':
        return 'Last 2 Weeks';
      case 'L1M':
        return 'This Month';
      default:
        return selectedDuration;
    }
  }
}

class _StackedArcPainter extends CustomPainter {
  final List<double> counts;
  final List<Color> colors;
  final double strokeWidth;
  final double gap;

  _StackedArcPainter({
    required this.counts,
    required this.colors,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double total = counts.fold(0.0, (a, b) => a + b);

    // Center lowered so the whole circle stays visible
    final Offset center = Offset(size.width / 2, size.height * 0.55);

    // Base radius fits inside the paint box
    final double baseRadius = size.width * 0.38;

    // 80% circle = 1.6π (~288 degrees)
    const double arcSweep = 1.6 * pi;

    // Center the arc visually
    const double startAngle = -pi / 2 - (arcSweep / 2);

    for (int i = 0; i < counts.length; i++) {
      final double r = baseRadius - (i * (strokeWidth + gap));
      if (r <= 0) continue;

      final rect = Rect.fromCircle(center: center, radius: r);

      // Background track
      final bgPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = Colors.grey.withOpacity(0.12);

      canvas.drawArc(rect, startAngle, arcSweep, false, bgPaint);

      // Foreground arc
      final double sweep = (total == 0) ? 0 : (counts[i] / total) * arcSweep;

      final fgPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = colors[i];

      canvas.drawArc(rect, startAngle, sweep, false, fgPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _StackedArcPainter oldDelegate) => true;
}
