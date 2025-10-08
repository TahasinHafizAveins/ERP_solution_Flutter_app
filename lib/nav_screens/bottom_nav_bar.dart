import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int index) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.green[200],
      unselectedItemColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.black87,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.contact_mail_rounded),
          label: 'Self Details',
          backgroundColor: Colors.black87,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Team Members',
          backgroundColor: Colors.black87,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.contacts),
          label: 'Employee Directory',
          backgroundColor: Colors.black87,
        ),
      ],
    );
  }
}
