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

class _PieChartAttendanceState extends State<PieChartAttendance>
    with SingleTickerProviderStateMixin {
  static const List<String> _fixedLabels = [
    'On Time',
    'Late',
    'Absent',
    'Leave',
    'Holiday & Weekend',
    'Partial Entry',
  ];

  static const List<Color> _fixedColors = [
    Color(0xFF2ECC71), // On Time
    Color(0xFFFFA726), // Late
    Color(0xFFEF5350), // Absent
    Color(0xFF42A5F5), // Leave
    Color(0xFF9C27B0), // Holiday & Weekend
    Color(0xFF26A69A), // Partial Entry
  ];

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    // Start animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void didUpdateWidget(PieChartAttendance oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Restart animation when selectedDuration changes
    if (oldWidget.selectedDuration != widget.selectedDuration ||
        oldWidget.attendanceResult != widget.attendanceResult) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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

    final List<double> counts = List.generate(_fixedLabels.length, (i) {
      final target = _fixedLabels[i].toLowerCase();
      final keywords = _keywordsForIndex(i);

      for (final apiLabel in apiMap.keys) {
        final lower = apiLabel.toLowerCase();
        for (final kw in keywords) {
          if (lower.contains(kw)) return apiMap[apiLabel] ?? 0.0;
        }
      }

      return apiMap[target] ?? 0.0;
    });

    // Max-day rule
    double maxDays = widget.selectedDuration == "LW"
        ? 5
        : widget.selectedDuration == "L2W"
        ? 10
        : 22; // L1M

    return Column(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return SizedBox(
              width: widget.scWidth,
              height: widget.scWidth * 0.45,
              child: CustomPaint(
                painter: StackedProgressArcPainter(
                  values: counts,
                  maxValue: maxDays,
                  colors: _fixedColors,
                  strokeWidth: widget.scWidth * 0.0095,
                  gap: widget.scWidth * 0.008,
                  animationValue: _animation.value,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        _centerSubtitle(widget.selectedDuration),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 14),
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
                    "${value.toString().padLeft(2, '0')} $label",
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
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  static List<String> _keywordsForIndex(int idx) {
    switch (idx) {
      case 0:
        return ['on time', 'ontime', 'on-time'];
      case 1:
        return ['late'];
      case 2:
        return ['absent', 'abs'];
      case 3:
        return ['leave'];
      case 4:
        return ['holiday', 'weekend'];
      case 5:
        return ['partial'];
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

class StackedProgressArcPainter extends CustomPainter {
  final List<double> values;
  final double maxValue;
  final List<Color> colors;
  final double strokeWidth;
  final double gap;
  final double animationValue;

  StackedProgressArcPainter({
    required this.values,
    required this.maxValue,
    required this.colors,
    required this.strokeWidth,
    required this.gap,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);

    final double baseRadius = size.width * 0.40;

    const double arcSweep = 1.6 * pi; // 80% circle
    const double startAngle = -pi / 2 - (arcSweep / 2);

    for (int i = 0; i < values.length; i++) {
      final r = baseRadius - (i * (strokeWidth + gap));
      if (r <= 0) continue;

      final rect = Rect.fromCircle(center: center, radius: r);

      // Draw background arc
      final bgPaint = Paint()
        ..color = Colors.grey.withOpacity(0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, startAngle, arcSweep, false, bgPaint);

      // Draw animated foreground arc
      final percent = (values[i] / maxValue).clamp(0.0, 1.0);
      final sweep = arcSweep * percent * animationValue;

      final fgPaint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, startAngle, sweep, false, fgPaint);
    }
  }

  @override
  bool shouldRepaint(covariant StackedProgressArcPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.values != values ||
        oldDelegate.maxValue != maxValue;
  }
}
