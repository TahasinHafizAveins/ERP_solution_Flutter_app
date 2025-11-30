import 'package:erp_solution/nav_screens/bottom_nav_bar.dart';
import 'package:erp_solution/nav_screens/drawer_menu_bar.dart';
import 'package:erp_solution/nav_screens/notifications.dart';
import 'package:erp_solution/nav_screens/top_menu_bar.dart';
import 'package:erp_solution/provider/attendance_summery_provider.dart';
import 'package:erp_solution/screens/attendance/self_details.dart';
import 'package:erp_solution/screens/attendance/user_attendence_summery.dart';
import 'package:erp_solution/screens/employee_dir/employee_directory.dart';
import 'package:erp_solution/screens/leave_management/self_leave_application_list.dart';
import 'package:erp_solution/screens/leave_management/team_leave_application_list.dart';
import 'package:erp_solution/screens/remote_attendance/remote_attendance.dart';
import 'package:erp_solution/screens/shimmer_screens/attendance_shimmer.dart';
import 'package:erp_solution/screens/team_attendance/team_mem_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/notification_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  Widget? _overridePage;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _overridePage = null;
    });

    if (index == 0) {
      _fetchAttendanceSummery(); // Re-fetch when Home is selected
    }
  }

  //  Handle drawer menu selection
  void _onDrawerMenuItemSelected(int menuId) {
    // Handle specific menu items
    switch (menuId) {
      case 25: // Replace with actual Remote Attendance menu ID from your JSON
        _openRemoteAttendance();
        break;
      case 124: // Replace with other menu IDs as needed
        _openOtherPage();
        break;
      case 163: // Replace with other menu IDs as needed
        _setEmployeeDirectoryAsCurrentPage();
        break;
      case 63: // Replace with other menu IDs as needed
        _openNotification();
        break;
      case 6: // Replace with other menu IDs as needed
        _openHome();
        break;
      case 54: // Replace with other menu IDs as needed
        _openSelfLeaveApplicationList();
        break;
      case 84: // Replace with other menu IDs as needed
        _openTeamLeaveApplicationList();
        break;

      default:
        // For unknown menu IDs, you can show a message or ignore
        debugPrint('Unknown menu ID: $menuId');
        break;
    }
  }

  void _openSelfLeaveApplicationList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelfLeaveApplicationList()),
    );
  }

  void _openTeamLeaveApplicationList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TeamLeaveApplicationList()),
    );
  }

  void _openRemoteAttendance() {
    // Navigate to Remote Attendance page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const RemoteAttendance(), // Your remote attendance page
      ),
    );
  }

  void _setEmployeeDirectoryAsCurrentPage() {
    setState(() {
      _overridePage = EmployeeDirectory(); // Use a different widget
      _selectedIndex = 3;
    });
  }

  void _openHome() {
    setState(() {
      _overridePage = null; // Clear any override page
      _selectedIndex = 0; // Set to first tab (Home/Attendance)
    });

    // Optionally refresh home data
    _fetchAttendanceSummery();
  }

  void _openNotification() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Notifications()),
    );
  }

  void _openOtherPage() {
    // Handle other menu items
    // You can add more navigation logic here for other menu items
    //Navigator.pop(context); // Just close the drawer
    // Or show a dialog/snackbar instead of navigating
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Feature coming soon!')));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() {
      _fetchAttendanceSummery();
      _loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceSummeryProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Nagad People & Culture',
                textAlign: TextAlign.start,
              ),
            ),
            body: const AttendanceShimmer(),
          );
        }
        if (provider.error != null) {
          return Scaffold(
            body: Center(child: Text('Error: ${provider.error}')),
          );
        }
        if (provider.summery == null) {
          return const Scaffold(body: Center(child: Text('No data available')));
        }
        final pages = [
          UserAttendanceSummery(
            summeryModel: provider.summery?.result?.firstWhere(
              (result) => result.id == 'DoughnutWidget',
            ),
            attendanceBarChartModel: provider.barChart,
          ),
          SelfDetails(
            selfDetails: provider.summery?.result?.firstWhere(
              (result) => result.id == 'widget10',
            ),
          ),
          TeamMemDetails(
            teamMemDetails: provider.summery?.result?.firstWhere(
              (result) => result.id == 'widget11',
            ),
          ),
          const EmployeeDirectory(),
        ];

        // Determine which page to show
        final Widget page;
        if (_overridePage != null) {
          page = _overridePage!;
        } else {
          page = pages[_selectedIndex];
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Nagad People & Culture',
              textAlign: TextAlign.start,
            ),
            actions: const [TopMenuBar()],
          ),
          drawer: DrawerMenuBar(onSelectedItem: _onDrawerMenuItemSelected),
          body: page,
          bottomNavigationBar: BottomNavBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onNavItemTapped,
          ),
        );
      },
    );
  }

  Future<void> _fetchAttendanceSummery() async {
    final provider = Provider.of<AttendanceSummeryProvider>(
      context,
      listen: false,
    );
    provider.loadAttendanceSummery();
    provider.loadAttendanceBarChart();
  }

  Future<void> _loadNotifications() async {
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    await provider.loadNotifications();
  }
}
