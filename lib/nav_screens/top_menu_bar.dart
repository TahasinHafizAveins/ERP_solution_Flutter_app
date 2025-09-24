import 'package:flutter/material.dart';

class TopMenuBar extends StatelessWidget {
  const TopMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_active),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_outlined),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'My Profile',
              child: Row(
                children: const [
                  Icon(Icons.person, color: Colors.black54),
                  SizedBox(width: 10),
                  Text('My Profile'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'Edit Profile',
              child: Row(
                children: [
                  const Icon(Icons.settings, color: Colors.black54),
                  const SizedBox(width: 10),
                  Text('Edit Profile'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'Change Password',
              child: Row(
                children: [
                  const Icon(Icons.lock_reset, color: Colors.black54),
                  const SizedBox(width: 10),
                  Text('Change Password'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'Logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.black54),
                  SizedBox(width: 10),
                  Text('Logout'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
