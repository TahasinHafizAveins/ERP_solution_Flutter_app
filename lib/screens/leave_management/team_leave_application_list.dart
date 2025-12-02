import 'package:erp_solution/models/leave_application_list_model.dart';
import 'package:erp_solution/provider/leave_management_provider.dart';
import 'package:erp_solution/screens/leave_management/leave_application_details.dart';
import 'package:erp_solution/screens/leave_management/team_leave_application_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TeamLeaveApplicationList extends StatefulWidget {
  const TeamLeaveApplicationList({super.key});

  @override
  State<TeamLeaveApplicationList> createState() =>
      _TeamLeaveApplicationListState();
}

class _TeamLeaveApplicationListState extends State<TeamLeaveApplicationList> {
  String?
  _selectedFilter; // 'Pending', 'Approved', 'Rejected', 'MyPending', or null for all

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<LeaveManagementProvider>(
        context,
        listen: false,
      );
      if (provider.teamLeaveApplications.isEmpty &&
          !provider.isTeamLeaveLoading) {
        provider.loadTeamLeaveApplicationList();
      }
    });
  }

  // Helper method to filter applications for current year
  List<LeaveApplicationListModel> _getCurrentYearApplications(
    List<LeaveApplicationListModel> applications,
  ) {
    final currentYear = DateTime.now().year;
    return applications.where((application) {
      try {
        final createdDate = DateTime.parse(application.createdDate!);
        return createdDate.year == currentYear;
      } catch (e) {
        try {
          final leaveDateParts = application.leaveDates!.split(' - ').first;
          final leaveDate = _parseDateString(leaveDateParts);
          return leaveDate?.year == currentYear;
        } catch (e) {
          return false;
        }
      }
    }).toList();
  }

  // Method to filter applications based on selected status
  List<LeaveApplicationListModel> _getFilteredApplications(
    List<LeaveApplicationListModel> applications,
  ) {
    if (_selectedFilter == null) {
      return applications; // Show all applications
    } else if (_selectedFilter == 'MyPending') {
      // Filter for My Pending - items where APEmployeeFeedbackID != 0
      return applications
          .where(
            (application) =>
                application.approvalStatus == 'Pending' &&
                (application.apEmployeeFeedbackID ?? 0) != 0,
          )
          .toList();
    } else {
      return applications
          .where((application) => application.approvalStatus == _selectedFilter)
          .toList();
    }
  }

  DateTime? _parseDateString(String dateString) {
    try {
      final parts = dateString.split(' ');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = _getMonthNumber(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      print('Error parsing date: $dateString');
    }
    return null;
  }

  int _getMonthNumber(String month) {
    const months = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12,
    };
    return months[month] ?? 1;
  }

  void _handleFilterClick(String? status) {
    setState(() {
      if (_selectedFilter == status) {
        // If clicking the same filter again, remove filter (show all)
        _selectedFilter = null;
      } else {
        // Apply new filter
        _selectedFilter = status;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Team Leave Applications',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red.shade700,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          // Clear filter button
          if (_selectedFilter != null)
            IconButton(
              onPressed: () {
                setState(() {
                  _selectedFilter = null;
                });
              },
              icon: const Icon(Icons.clear_all_rounded),
              tooltip: 'Clear Filter',
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red.shade50, Colors.grey.shade50],
          ),
        ),
        child: Consumer<LeaveManagementProvider>(
          builder: (context, provider, child) {
            if (provider.isTeamLeaveLoading) {
              return _buildLoadingState();
            }

            if (provider.teamLeaveError != null) {
              return _buildErrorState(provider.teamLeaveError!, provider);
            }

            final applications = provider.teamLeaveApplications;
            final filteredApplications = _getFilteredApplications(applications);

            if (filteredApplications.isEmpty) {
              return _buildEmptyState(provider, _selectedFilter);
            }

            return _buildLeaveList(filteredApplications, applications);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Shimmer Header Card
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              height: 100,
            ),
          ),

          // Shimmer Team Leave Cards
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: 6,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildShimmerCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Shimmer Profile Image
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),

              // Shimmer Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First Row: Employee Name and Status
                    Row(
                      children: [
                        // Shimmer Employee Name
                        Container(
                          height: 18,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const Spacer(),
                        // Shimmer Status Badge
                        Container(
                          height: 28,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Second Row: Leave Type
                    Container(
                      height: 16,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Third Row: Date
                    Row(
                      children: [
                        // Shimmer Calendar Icon
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Shimmer Date Text
                        Container(
                          height: 16,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Fourth Row: Duration
                    Container(
                      height: 28,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error, LeaveManagementProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 80,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 20),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              error,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => provider.loadTeamLeaveApplicationList(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
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
    );
  }

  Widget _buildEmptyState(LeaveManagementProvider provider, String? filter) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                filter == null
                    ? Icons.people_alt_rounded
                    : Icons.search_off_rounded,
                size: 60,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              filter == null
                  ? 'No Team Leave Applications'
                  : filter == 'MyPending'
                  ? 'No My Pending Leaves'
                  : 'No $filter Leaves Found',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              filter == null
                  ? 'Your team hasn\'t applied for any leaves yet.'
                  : filter == 'MyPending'
                  ? 'You don\'t have any pending leaves requiring your feedback.'
                  : 'There are no $filter leaves in your team.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            if (filter != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _handleFilterClick(null),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Show All Leaves'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveList(
    List<LeaveApplicationListModel> filteredApplications,
    List<LeaveApplicationListModel> allApplications,
  ) {
    final currentYearApplications = _getCurrentYearApplications(
      allApplications,
    );
    final currentYear = DateTime.now().year;

    // Calculate My Pending count
    final myPendingCount = currentYearApplications
        .where(
          (application) =>
              application.approvalStatus == 'Pending' &&
              (application.apEmployeeFeedbackID ?? 0) != 0,
        )
        .length;

    return Column(
      children: [
        // Header with current year stats (4 items now)
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade600, Colors.red.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.red.shade300.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Year indicator and filter status
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _selectedFilter == null
                        ? 'Team Leave Summary - $currentYear'
                        : _selectedFilter == 'MyPending'
                        ? 'Showing: My Pending Leaves'
                        : 'Showing: $_selectedFilter Leaves',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'My Pending',
                    myPendingCount.toString(),
                    Icons.person_pin_rounded,
                    isSelected: _selectedFilter == 'MyPending',
                    onTap: () => _handleFilterClick('MyPending'),
                  ),
                  _buildStatItem(
                    'Pending',
                    currentYearApplications
                        .where((a) => a.approvalStatus == 'Pending')
                        .length
                        .toString(),
                    Icons.pending_actions_rounded,
                    isSelected: _selectedFilter == 'Pending',
                    onTap: () => _handleFilterClick('Pending'),
                  ),
                  _buildStatItem(
                    'Approved',
                    currentYearApplications
                        .where((a) => a.approvalStatus == 'Approved')
                        .length
                        .toString(),
                    Icons.verified_rounded,
                    isSelected: _selectedFilter == 'Approved',
                    onTap: () => _handleFilterClick('Approved'),
                  ),
                  _buildStatItem(
                    'Rejected',
                    currentYearApplications
                        .where((a) => a.approvalStatus == 'Rejected')
                        .length
                        .toString(),
                    Icons.cancel_rounded,
                    isSelected: _selectedFilter == 'Rejected',
                    onTap: () => _handleFilterClick('Rejected'),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Team Leave List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: filteredApplications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final leave_application = filteredApplications[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: () {
                    _onLeaveItemTap(leave_application);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: TeamLeaveApplicationCard(
                    application: leave_application,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
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
              color: isSelected ? Colors.red.shade700 : Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _onLeaveItemTap(LeaveApplicationListModel leaveApplication) {
    print("###############^^^:B:  ${leaveApplication.employeeLeaveAID}");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LeaveApplicationDetails(
          type: 1,
          ref: leaveApplication.employeeLeaveAID!,
          originateFrom: "TeamLeaveApplication",
        ),
      ),
    ).then((_) {
      // This callback runs when returning from the details page
      _refreshData();
    });
  }

  void _refreshData() {
    final provider = Provider.of<LeaveManagementProvider>(
      context,
      listen: false,
    );
    provider.loadTeamLeaveApplicationList(); // Refresh the list
  }
}
