import 'package:erp_solution/nav_screens/bottom_nav_bar.dart';
import 'package:erp_solution/nav_screens/drawer_menu_bar.dart';
import 'package:erp_solution/nav_screens/top_menu_bar.dart';
import 'package:erp_solution/screens/employee_directory.dart';
import 'package:erp_solution/screens/self_details.dart';
import 'package:erp_solution/screens/team_mem_details.dart';
import 'package:erp_solution/screens/user_attendence_summery.dart';
import 'package:flutter/material.dart';

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
  }

  final List<Widget> _pages = [
    const UserAttendanceSummery(),
    const SelfDetails(),
    const TeamMemDetails(),
    const EmployeeDirectory(),
  ];

  @override
  Widget build(BuildContext context) {
    final page = _overridePage ?? _pages[_selectedIndex];
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
  }
}
