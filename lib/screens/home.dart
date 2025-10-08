import 'package:erp_solution/nav_screens/bottom_nav_bar.dart';
import 'package:erp_solution/nav_screens/drawer_menu_bar.dart';
import 'package:erp_solution/nav_screens/top_menu_bar.dart';
import 'package:erp_solution/provider/attendance_summery_provider.dart';
import 'package:erp_solution/screens/attendance/self_details.dart';
import 'package:erp_solution/screens/attendance/user_attendence_summery.dart';
import 'package:erp_solution/screens/employee_dir/employee_directory.dart';
import 'package:erp_solution/screens/shimmer_screens/attendance_shimmer.dart';
import 'package:erp_solution/screens/team_attendance/team_mem_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() => _fetchAttendanceSummery());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceSummeryProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('ERP Solution', textAlign: TextAlign.start),
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

        final page = _overridePage ?? pages[_selectedIndex];

        return Scaffold(
          appBar: AppBar(
            title: const Text('ERP Solution', textAlign: TextAlign.start),
            actions: const [TopMenuBar()],
          ),
          drawer: DrawerMenuBar(onSelectedItem: _onNavItemTapped),
          body: page,
          bottomNavigationBar: BottomNavBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onNavItemTapped,
          ),
        );
        Scaffold(
          appBar: AppBar(
            title: const Text('ERP Solution', textAlign: TextAlign.start),
            actions: const [TopMenuBar()],
          ),
          drawer: DrawerMenuBar(onSelectedItem: _onNavItemTapped),
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
  }
}
