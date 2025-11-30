import 'package:erp_solution/models/notification_model.dart';
import 'package:erp_solution/provider/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../screens/leave_management/team_leave_application_list.dart';
import '../screens/shimmer_screens/notification_shimmer.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final provider = Provider.of<NotificationProvider>(context, listen: false);
    Future.microtask(() async {
      await provider.loadNotificationTypes();
      await provider.loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Notifications',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: NotificationShimmer(),
          );
        }

        if (provider.error != null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Notifications',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: Center(child: Text('Error: ${provider.error}')),
          );
        }
        final notifications = provider.notifications ?? [];
        final apiTypes =
            provider.notificationTypes
                ?.map((e) => e.aPTypeName?.trim())
                .where((t) => t != null && t.isNotEmpty)
                .cast<String>()
                .toList() ??
            [];
        final notificationTypes = ['All', ...apiTypes];

        // filter and search logic
        final filterList = notifications.where((n) {
          final matchesFilter =
              _selectedFilter == 'All' || n.aPTypeName == _selectedFilter;
          final matchesSearch =
              (n.title ?? '').toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              (n.aPTypeName ?? '').toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
          return matchesFilter && matchesSearch;
        }).toList();

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Notifications',
              style: GoogleFonts.poppins(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            actions: [
              Consumer<NotificationProvider>(
                builder: (context, provider, _) {
                  if (provider.unreadCount == 0) return const SizedBox.shrink();
                  return IconButton(
                    icon: const Icon(Icons.mark_email_read),
                    onPressed: () {
                      provider.markAllAsRead();
                    },
                    tooltip: 'Mark all as read',
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Smart search + filter row
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: GoogleFonts.poppins(fontSize: 14),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        final selected = await showModalBottomSheet<String>(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) =>
                              _buildFilterSheet(notificationTypes),
                        );
                        if (selected != null) {
                          setState(() => _selectedFilter = selected);
                        }
                      },
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Colors.red.shade700,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.filter_list,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Notifications list
              Expanded(
                child: filterList.isEmpty
                    ? Center(
                        child: Text(
                          "No notifications found",
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filterList.length,
                        itemBuilder: (context, index) {
                          final n = filterList[index];
                          final isTappable = n.aPTypeID == 1;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              onTap: isTappable
                                  ? () {
                                      // Mark notification as read when tapped
                                      final provider =
                                          Provider.of<NotificationProvider>(
                                            context,
                                            listen: false,
                                          );
                                      provider.markAsRead(n);

                                      // Add your navigation logic for APTypeID == 1 here
                                      _handleTappableNotification(n);
                                    }
                                  : null,
                              leading: CircleAvatar(
                                backgroundColor: Colors.red.shade50,
                                child: Icon(
                                  Icons.notifications,
                                  color: Colors.red.shade700,
                                ),
                              ),
                              title: Text(
                                n.title != null ? "\n${n.title}" : 'No Title',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              subtitle: Text(
                                "\n${n.aPTypeName} • ${n.feedbackRequestDate}",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterSheet(List<String> notificationTypes) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Filter by Type',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: notificationTypes.map((type) {
              final isSelected = _selectedFilter == type;
              return ChoiceChip(
                label: Text(type),
                selected: isSelected,
                selectedColor: Colors.red.shade700,
                backgroundColor: Colors.grey.shade200,
                labelStyle: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                onSelected: (_) => Navigator.pop(context, type),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _handleTappableNotification(NotificationModel notification) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TeamLeaveApplicationList()),
    );
  }
}
