import 'package:erp_solution/models/menu_model.dart';
import 'package:erp_solution/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/api_end_points.dart';

class DrawerMenuBar extends StatefulWidget {
  final void Function(int index) onSelectedItem;

  const DrawerMenuBar({super.key, required this.onSelectedItem});

  @override
  State<DrawerMenuBar> createState() => _DrawerMenuBarState();
}

class _DrawerMenuBarState extends State<DrawerMenuBar> {
  String? _selectedMenuKey;
  final Map<int, bool> _expanded = {};

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user?.result;
    final menus = user?.menus?.result ?? [];

    final topLevelMenus = menus.where((menu) => menu.parentID == 0).toList();
    final displayMenus = topLevelMenus
        .map((topMenu) => buildMenuTree(menus, parentId: topMenu.menuID ?? 0))
        .expand((menuList) => menuList)
        .toList();

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.93,
      child: Column(
        children: [
          // Profile header
          Container(
            color: Colors.transparent,
            child: Column(
              children: [
                // 1️⃣ Gradient header with curved bottom
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.2, 0, 0.2, 0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red.shade900, Colors.red.shade300],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(45),
                        bottomRight: Radius.circular(45),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            0.2,
                          ), // FIX: Changed from withValues to withOpacity
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        // Avatar
                        CircleAvatar(
                          radius: 85,
                          backgroundImage: getImage(user?.imagePath),
                        ),
                        const SizedBox(height: 12),
                        // Name
                        Text(
                          user?.fullName ?? "....",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Role
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              user?.designationName ?? "..",
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 10), // FIX: Added const
                            Text(
                              user?.employeeCode?.toString() ??
                                  "..", // FIX: Added null check
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () =>
                                  debugPrint("Edit Profile tapped"),
                              icon: const Icon(Icons.edit, size: 16),
                              label: Text(
                                "Edit",
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.red.shade700,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: () => _logout(context),
                              icon: const Icon(Icons.logout, size: 16),
                              label: Text(
                                "Logout",
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.red.shade700,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20), // spacing before menu
              ],
            ),
          ),

          // Dynamic menu list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0), // FIX: Added const
              itemCount: displayMenus.length,
              itemBuilder: (context, index) {
                return _buildMenuItem(displayMenus[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider getImage(String? s) {
    if (s == null || s.isEmpty) {
      // fallback image
      return const AssetImage('assets/images/profile.jpg');
    }
    return NetworkImage("${ApiEndPoints.base}${ApiEndPoints.imageApi}$s");
  }

  List<MenuResult> buildMenuTree(
    List<MenuResult> allMenus, {
    int parentId = 0,
  }) {
    return allMenus
        .where((menu) => menu.parentID == parentId && menu.target == "app")
        .map((menu) {
          final children = buildMenuTree(allMenus, parentId: menu.menuID ?? 0);
          return MenuResult(
            menuID: menu.menuID,
            parentID: menu.parentID,
            title: menu.title,
            type: menu.type,
            icon: menu.icon,
            url: menu.url,
            // 👇 attach children dynamically
            children: children.isNotEmpty ? children : null,
          );
        })
        .toList();
  }

  Widget _buildMenuItem(MenuResult menu, {int depth = 0}) {
    final key = menu.iD ?? menu.title ?? "menu_${menu.menuID}";
    final hasChildren = menu.children != null && menu.children!.isNotEmpty;
    final menuId = menu.menuID ?? -1;
    final isExpanded = _expanded[menuId] ?? false;
    final isSelected = key == _selectedMenuKey;

    IconData iconData = Icons.circle;

    final header = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: EdgeInsets.only(left: depth * 14.0, right: 2, top: 6, bottom: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: isSelected
            ? LinearGradient(
                colors: [
                  Colors.red.shade700.withOpacity(
                    0.95,
                  ), // FIX: Changed from withValues to withOpacity
                  Colors.red.shade400.withOpacity(
                    0.9,
                  ), // FIX: Changed from withValues to withOpacity
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isSelected ? null : Colors.white,
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? Colors.red.shade700.withOpacity(
                    0.15,
                  ) // FIX: Changed from withValues to withOpacity
                : Colors.black.withOpacity(
                    0.03,
                  ), // FIX: Changed from withValues to withOpacity
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          if (hasChildren) {
            setState(() => _expanded[menuId] = !isExpanded);
          } else {
            // Handle menu item selection
            setState(() => _selectedMenuKey = key);

            final selectedMenuId = menu.menuID ?? 0;
            if (selectedMenuId == 25 ||
                selectedMenuId == 163 ||
                selectedMenuId == 63 ||
                selectedMenuId == 6) {
              // FIX: Use a small delay to ensure drawer closes properly before callback
              Future.delayed(const Duration(milliseconds: 100), () {
                Navigator.pop(context); // Close drawer
                widget.onSelectedItem(selectedMenuId); // Trigger callback
              });
            } else {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Feature coming soon!')),
              );
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  size: 18,
                  color: isSelected ? Colors.red.shade700 : Colors.red.shade300,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  menu.title ?? '',
                  style: GoogleFonts.poppins(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 15,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasChildren)
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0.0,
                  duration: const Duration(milliseconds: 220),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                    size: 22,
                  ),
                )
              else if (menu.badge != null && menu.badge!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.red.shade700,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    menu.badge!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isSelected ? Colors.red.shade700 : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    if (!hasChildren) return header;

    return Column(
      children: [
        header,
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: EdgeInsets.only(left: (depth + 1) * 14.0, right: 12),
            child: Column(
              children: menu.children!
                  .map((child) => _buildMenuItem(child, depth: depth + 1))
                  .toList(),
            ),
          ),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }

  void _logout(BuildContext context) {
    context.read<AuthProvider>().logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
