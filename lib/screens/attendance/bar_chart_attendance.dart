import 'package:erp_solution/models/attendance_bar_chart_model.dart';
import 'package:erp_solution/models/attendance_summery_result_model.dart'
    hide Datasets;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartAttendance extends StatefulWidget {
  final String selectedDuration;
  final Result? attendanceResult;
  final AttendanceBarChartModel? attendanceBarChartModel;

  const BarChartAttendance({
    super.key,
    required this.selectedDuration,
    required this.attendanceResult,
    required this.attendanceBarChartModel,
  });

  @override
  State<BarChartAttendance> createState() => _BarChartAttendanceState();
}

class _BarChartAttendanceState extends State<BarChartAttendance>
    with SingleTickerProviderStateMixin {
  // Updated color scheme for bar chart with third color
  final List<Color> _barChartColors = [
    const Color(0xFF4CAF50), // Green for Actual Work Hour
    const Color(0xFFFF9800), // Orange for Expected Work Hour
    const Color(0xFF2196F3), // Blue for Average Work Hour (NEW COLOR ADDED)
  ];

  final List<Color> _barChartHoverColors = [
    const Color(0xFF66BB6A), // Light Green
    const Color(0xFFFFB74D), // Light Orange
    const Color(0xFF64B5F6), // Light Blue (NEW COLOR ADDED)
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
      duration: const Duration(milliseconds: 1200),
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
  void didUpdateWidget(BarChartAttendance oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Restart animation when selectedDuration changes
    if (oldWidget.selectedDuration != widget.selectedDuration ||
        oldWidget.attendanceBarChartModel != widget.attendanceBarChartModel) {
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
    return _buildBarChartContent();
  }

  Widget _buildBarChartContent() {
    final barData = _getBarChartData();
    if (barData == null) {
      return const Center(child: Text("No bar chart data available"));
    }

    final labels = barData.labels ?? [];
    final datasets = barData.datasets ?? [];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Column(
        children: [
          Center(
            child: Text(
              "${widget.attendanceBarChartModel?.title} - ${_getBarChartRange()}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.brown[900],
              ),
            ),
          ),
          const SizedBox(height: 10),

          _buildBarChartLegend(datasets),
          const SizedBox(height: 10),

          SizedBox(
            height: 300, // Fixed height for bar chart
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceBetween,
                    maxY: _getMaxYValue(datasets),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final datasetLabel = datasets[rodIndex].label ?? '';
                          return BarTooltipItem(
                            '$datasetLabel: ${rod.toY.toStringAsFixed(2)}h',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < labels.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  _formatLabelForDisplay(
                                    labels[index],
                                    labels.length,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                            return const Text('');
                          },
                          reservedSize: 40,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}h',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            );
                          },
                          reservedSize: 40,
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: const FlGridData(show: true),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    barGroups: _buildBarGroups(labels, datasets),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          _buildBarChartFooter(),
        ],
      ),
    );
  }

  Widget _buildBarChartLegend(List<Datasets> datasets) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 5,
          children: datasets.asMap().entries.map((entry) {
            final index = entry.key;
            final dataset = entry.value;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20,
                  height: 4,
                  color: _getBarChartColor(index),
                ),
                const SizedBox(width: 8),
                Text(
                  dataset.label ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBarChartFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.attendanceBarChartModel?.footerLeft != null)
            _buildFooterItem(
              widget.attendanceBarChartModel!.footerLeft!,
              Icons.access_time,
              _barChartColors[0],
            ),
          if (widget.attendanceBarChartModel?.footerRight != null)
            _buildFooterItem(
              widget.attendanceBarChartModel!.footerRight!,
              Icons.timelapse,
              _barChartColors[1],
            ),
          _buildAverageWorkHourItem(),
        ],
      ),
    );
  }

  Widget _buildFooterItem(FooterLeft footer, IconData icon, Color color) {
    double count = 0;
    if (widget.selectedDuration == "LW") {
      count = footer.count?.tW ?? 0;
    } else if (widget.selectedDuration == "L2W") {
      count = footer.count?.l2W ?? 0;
    } else if (widget.selectedDuration == "L1M") {
      count = footer.count?.l1M ?? 0;
    }

    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Icon(icon, size: 24, color: color),
              const SizedBox(height: 8),
              Text(
                '${count.toStringAsFixed(2)}h',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                footer.title ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAverageWorkHourItem() {
    // Calculate average work hours per day based on selected duration
    double averageWorkHours = _calculateAverageWorkHours();

    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Icon(Icons.av_timer, size: 24, color: _barChartColors[2]),
              const SizedBox(height: 8),
              Text(
                '${averageWorkHours.toStringAsFixed(2)}h',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _barChartColors[2],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Avg/Day',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateAverageWorkHours() {
    // Get the bar chart data for the selected duration
    final barData = _getBarChartData();

    if (barData == null) return 0;

    final datasets = barData.datasets ?? [];
    if (datasets.isEmpty || datasets[0].data == null) return 0;

    // Get total work hours for the selected duration
    double totalWorkHours = 0;
    if (widget.selectedDuration == "LW") {
      totalWorkHours =
          widget.attendanceBarChartModel?.footerLeft?.count?.tW ?? 0;
    } else if (widget.selectedDuration == "L2W") {
      totalWorkHours =
          widget.attendanceBarChartModel?.footerLeft?.count?.l2W ?? 0;
    } else if (widget.selectedDuration == "L1M") {
      totalWorkHours =
          widget.attendanceBarChartModel?.footerLeft?.count?.l1M ?? 0;
    }

    // Calculate number of actual working days (days with non-zero work hours)
    final workHoursData = datasets[0].data!;
    int numberOfDays = workHoursData.where((hours) => hours > 0).length;

    // If no days with work hours, use total number of days in the dataset
    if (numberOfDays == 0) {
      numberOfDays = workHoursData.length;
    }

    // Calculate average (avoid division by zero)
    return numberOfDays > 0 ? totalWorkHours / numberOfDays : 0;
  }

  // Helper methods for bar chart
  TW? _getBarChartData() {
    switch (widget.selectedDuration) {
      case "LW":
        return widget.attendanceBarChartModel?.mainChart?.tW;
      case "L2W":
        return widget.attendanceBarChartModel?.mainChart?.l2W;
      case "L1M":
        return widget.attendanceBarChartModel?.mainChart?.l1M;
      default:
        return null;
    }
  }

  String _getBarChartRange() {
    switch (widget.selectedDuration) {
      case "LW":
        return widget.attendanceBarChartModel?.ranges?.tW ?? "Last Week";
      case "L2W":
        return widget.attendanceBarChartModel?.ranges?.l2W ?? "Last 2 Weeks";
      case "L1M":
        return widget.attendanceBarChartModel?.ranges?.l1M ?? "Last 30 Days";
      default:
        return "";
    }
  }

  double _getMaxYValue(List<Datasets> datasets) {
    double maxY = 10;
    for (var dataset in datasets) {
      final maxInDataset = dataset.data?.reduce((a, b) => a > b ? a : b) ?? 0;
      if (maxInDataset.toDouble() > maxY) {
        maxY = maxInDataset.toDouble();
      }
    }
    return maxY * 1.2;
  }

  List<BarChartGroupData> _buildBarGroups(
    List<String> labels,
    List<Datasets> datasets,
  ) {
    return List.generate(labels.length, (index) {
      final actualWorkHour = datasets[0].data?[index] ?? 0;
      final expectedWorkHour = datasets[1].data?[index] ?? 0;

      // Apply animation only to actual work hour
      final animatedActualWorkHour =
          actualWorkHour.toDouble() * _animation.value;
      final staticExpectedWorkHour = expectedWorkHour.toDouble();

      // Determine which value is shorter
      final isActualShorter = animatedActualWorkHour <= staticExpectedWorkHour;
      final shorterValue = isActualShorter
          ? animatedActualWorkHour
          : staticExpectedWorkHour;
      final longerValue = isActualShorter
          ? staticExpectedWorkHour
          : animatedActualWorkHour;

      return BarChartGroupData(
        x: index,
        groupVertically: true,
        barRods: [
          // Longer bar first (goes to back) - Expected Work Hour (no animation)
          BarChartRodData(
            toY: longerValue,
            color: isActualShorter
                ? _barChartColors[1] // Expected - lighter when behind
                : _barChartColors[0].withOpacity(
                    0.7,
                  ), // Actual - lighter when behind
            width: 14, // Wider bar for background
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          // Shorter bar second (comes to front) - Actual Work Hour (animated)
          BarChartRodData(
            toY: shorterValue,
            color: isActualShorter
                ? _barChartColors[0] // Actual - solid color when in front
                : _barChartColors[1].withOpacity(
                    0.7,
                  ), // Expected - lighter when in front
            width: 8, // Narrower bar for foreground
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    });
  }

  Color _getBarChartColor(int datasetIndex) {
    // Use hover colors when touched, normal colors otherwise
    final isTouched = false; // You can implement touch detection if needed
    if (isTouched && datasetIndex < _barChartHoverColors.length) {
      return _barChartHoverColors[datasetIndex];
    }
    return datasetIndex < _barChartColors.length
        ? _barChartColors[datasetIndex]
        : _barChartColors[0];
  }

  String _formatLabelForDisplay(String label, int totalLabels) {
    // For 30 days view only - show fewer labels to avoid overlap
    if (totalLabels > 20) {
      // 30 days view
      final parts = label.split(' ');
      if (parts.length == 2) {
        final day = int.tryParse(parts[1]);
        // Show only every 3rd day to prevent overlap
        if (day != null && day % 3 == 0) {
          return '${parts[0].substring(0, 3)}\n$day';
        } else {
          return ''; // Hide other labels to reduce clutter
        }
      }
      return '';
    } else {
      // For week and 2-week views, show all labels
      final parts = label.split(' ');
      if (parts.length == 2) {
        return '${parts[0].substring(0, 3)}\n${parts[1]}';
      }
      return label;
    }
  }
}
