import 'package:cached_network_image/cached_network_image.dart';
import 'package:erp_solution/models/attendance_summery_model.dart';
import 'package:erp_solution/models/attendance_summery_result_model.dart';
import 'package:erp_solution/utils/api_end_points.dart';
import 'package:erp_solution/utils/common_utils.dart';
import 'package:erp_solution/utils/self_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../provider/team_mem_attendance_details_provider.dart';

class SelectedMemberDetails extends StatefulWidget {
  const SelectedMemberDetails({super.key});

  @override
  State<SelectedMemberDetails> createState() => _SelectedMemberDetailsState();
}

class _SelectedMemberDetailsState extends State<SelectedMemberDetails> {
  String? _selectedFilter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String userId = args['id'] as String;

    final provider = Provider.of<TeamMemAttendanceDetailsProvider>(
      context,
      listen: false,
    );
    provider.loadTeamAttendanceDetails(userId);
  }

  // Calculate attendance statistics
  Map<String, int> _calculateStats(AttendanceSummeryModel? summery) {
    final rows =
        summery?.result
            ?.firstWhere(
              (result) => result.id == 'widget10',
              orElse: () => Result(),
            )
            .table
            ?.rows ??
        [];

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

    return {
      'total': total,
      'present': present,
      'late': late,
      'absent': absent,
      'leave': leave,
    };
  }

  // Filter attendance based on status
  List<Rows> _getFilteredAttendance(AttendanceSummeryModel? summery) {
    final allRows =
        summery?.result
            ?.firstWhere(
              (result) => result.id == 'widget10',
              orElse: () => Result(),
            )
            .table
            ?.rows ??
        [];

    if (_selectedFilter == null) {
      return allRows;
    }

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
      if (_selectedFilter == status) {
        _selectedFilter = null;
      } else {
        _selectedFilter = status;
      }
    });
  }

  Widget _buildHeaderWithProfileAndSummary(
    List<Cells> teamDetail,
    AttendanceSummeryModel? summery,
  ) {
    final String name = CommonUtils.getValue(teamDetail, "FullName");
    final String designation = CommonUtils.getValue(
      teamDetail,
      "DesignationName",
    );
    final String imageUrl =
        "${ApiEndPoints.base}${ApiEndPoints.imageApi}${CommonUtils.getValue(teamDetail, "avatar")}";
    final stats = _calculateStats(summery);

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        gradient: LinearGradient(
          colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // Profile Section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Image
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: const EdgeInsets.all(20),
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: InteractiveViewer(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.contain,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        height: 300,
                                        width: double.infinity,
                                        color: Colors.white,
                                      ),
                                    ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                      Icons.error,
                                      size: 100,
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.person,
                            size: 35,
                            color: Colors.red[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Name and Designation
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          designation,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Attendance Summary Card
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFFEF5350,
                  ).withOpacity(0.3), // Red 400 with opacity
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header with filter indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 18,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _selectedFilter == null
                              ? 'Attendance Summary'
                              : 'Filtered: $_selectedFilter',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (_selectedFilter != null)
                      GestureDetector(
                        onTap: () => _handleFilterClick(null),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 1,
                            ),
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
                const SizedBox(height: 16),

                // Stats Grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildRedThemeStatItem(
                      'Total',
                      stats['total'].toString(),
                      Icons.calendar_view_day_rounded,
                      isSelected: _selectedFilter == null,
                    ),
                    _buildRedThemeStatItem(
                      'On Time',
                      stats['present'].toString(),
                      Icons.check_circle_outline_rounded,
                      isSelected: _selectedFilter == 'On Time',
                    ),
                    _buildRedThemeStatItem(
                      'Late',
                      stats['late'].toString(),
                      Icons.access_time_rounded,
                      isSelected: _selectedFilter == 'Late',
                    ),
                    _buildRedThemeStatItem(
                      'Absent',
                      stats['absent'].toString(),
                      Icons.highlight_off_rounded,
                      isSelected: _selectedFilter == 'Absent',
                    ),
                    _buildRedThemeStatItem(
                      'Leave',
                      stats['leave'].toString(),
                      Icons.beach_access_rounded,
                      isSelected: _selectedFilter == 'Leave',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedThemeStatItem(
    String title,
    String value,
    IconData icon, {
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _handleFilterClick(title == 'Total' ? null : title),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? const Color(0xFFD32F2F) // Red 700
                  : Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.9),
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFilteredState() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'No $_selectedFilter Attendance',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _handleFilterClick(null),
            style: TextButton.styleFrom(foregroundColor: Colors.red[700]),
            child: const Text('Show All Records'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final List<Cells> teamDetail = args['teamDetail'] as List<Cells>;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance Details',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFD32F2F),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Consumer<TeamMemAttendanceDetailsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return _buildLoadingState(teamDetail);
          }

          if (provider.error != null) {
            return _buildErrorState(provider.error!, provider);
          }

          final filteredRows = _getFilteredAttendance(provider.summery);

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFEBEE), Color(0xFFFAFAFA)],
              ),
            ),
            child: Column(
              children: [
                // Header with Profile & Summary
                _buildHeaderWithProfileAndSummary(teamDetail, provider.summery),

                // Attendance List
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 20,
                    ),
                    child: filteredRows.isEmpty
                        ? _buildEmptyFilteredState()
                        : ListView.separated(
                            padding: const EdgeInsets.only(bottom: 16),
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(List<Cells> teamDetail) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFEBEE), Color(0xFFFAFAFA)],
        ),
      ),
      child: Column(
        children: [
          // Header Shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                color: Color(0xFFD32F2F),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                    child: Row(
                      children: [
                        Container(
                          width: 74,
                          height: 74,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 24,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                height: 30,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 20,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            5,
                            (index) => Column(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 12,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Shimmer Cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    String error,
    TeamMemAttendanceDetailsProvider provider,
  ) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String userId = args['id'] as String;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFEBEE), Color(0xFFFAFAFA)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 80,
                color: Colors.red[400],
              ),
              const SizedBox(height: 20),
              Text(
                'Failed to load attendance',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF424242),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                error,
                style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => provider.loadTeamAttendanceDetails(userId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods for existing functionality
  int? getItemCount(AttendanceSummeryModel? summery) {
    final summeryModel = summery?.result?.firstWhere(
      (result) => result.id == 'widget10',
    );
    return summeryModel?.table?.rows?.length;
  }

  List<Cells>? getItemValues(AttendanceSummeryModel? summery, int index) {
    final summeryModel = summery?.result?.firstWhere(
      (result) => result.id == 'widget10',
    );
    return summeryModel?.table?.rows?[index].cells;
  }
}
