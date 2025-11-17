import 'package:erp_solution/models/attendance_bar_chart_model.dart';
import 'package:erp_solution/models/attendance_summery_result_model.dart'
    hide Datasets;
import 'package:fl_chart/fl_chart.dart';
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

  // New color scheme for bar chart
  final List<Color> _barChartColors = [
    const Color(0xFF4CAF50), // Green for Actual Work Hour
    const Color(0xFFFF9800), // Orange for Expected Work Hour
  ];

  final List<Color> _barChartHoverColors = [
    const Color(0xFF66BB6A), // Light Green
    const Color(0xFFFFB74D), // Light Orange
  ];

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
                _buildPieChartContent(scWidth)
              else if (_selectedChartIndex == 1 && hasBarChart)
                _buildBarChartContent()
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

  Widget _buildPieChartContent(double scWidth) {
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
              centerSpaceRadius: scWidth / 12,
              sectionsSpace: 1,
              sections: List.generate(values.length, (i) {
                final value = values[i].toDouble();
                final sectionValue = value == 0 ? 0.001 : value;
                final isTouched = i == touchedIndex;
                final radius = isTouched ? scWidth / 10 : scWidth / 11;
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
                fontSize: 18,
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
            child: BarChart(
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
            ),
          ),
          const SizedBox(height: 10),

          _buildBarChartFooter(),
        ],
      ),
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
      final bars = List.generate(datasets.length, (datasetIndex) {
        final data = datasets[datasetIndex].data ?? [];
        final value = index < data.length ? data[index] : 0;

        return BarChartRodData(
          toY: value.toDouble(),
          color: _getBarChartColor(datasetIndex),
          width: 12,
          borderRadius: BorderRadius.circular(4),
        );
      });

      return BarChartGroupData(x: index, groupVertically: true, barRods: bars);
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

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Color _getSectionColor(String hex, bool isTouched) {
    final baseColor = _hexToColor(hex);
    if (!isTouched) return baseColor;
    return baseColor.withOpacity(0.7);
  }
}
