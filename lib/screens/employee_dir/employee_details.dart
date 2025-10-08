import 'package:cached_network_image/cached_network_image.dart';
import 'package:erp_solution/models/employee_dir_model.dart';
import 'package:erp_solution/utils/api_end_points.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeDetails extends StatelessWidget {
  const EmployeeDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final EmployeeDirModel employee =
        ModalRoute.of(context)!.settings.arguments as EmployeeDirModel;

    String imageUrl =
        (employee.imagePath != null && employee.imagePath!.isNotEmpty)
        ? "${ApiEndPoints.base}${ApiEndPoints.imageApi}${employee.imagePath}"
        : "https://cdn-icons-png.flaticon.com/512/149/149071.png";

    return Scaffold(
      appBar: AppBar(
        title: Text(employee.fullName ?? "Employee Details"),
        backgroundColor: Colors.red.shade400,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
                gradient: LinearGradient(
                  colors: [Colors.red.shade400, Colors.red.shade500],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Profile Image with tap-to-enlarge
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
                                borderRadius: BorderRadius.circular(16),
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          width: double.infinity,
                                          height: 300,
                                          color: Colors.white,
                                        ),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                        Icons.broken_image,
                                        size: 100,
                                        color: Colors.grey,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Name
                  Text(
                    employee.fullName ?? "-",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Employee Code
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
                      "Employee Code: ${employee.employeeCode ?? '-'}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Call & Email buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed:
                            employee.workMobile != null &&
                                employee.workMobile!.isNotEmpty
                            ? () => launchUrl(
                                Uri.parse('tel:${employee.workMobile}'),
                              )
                            : null,
                        icon: const Icon(Icons.phone),
                        label: const Text("Call"),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed:
                            employee.workEmail != null &&
                                employee.workEmail!.isNotEmpty
                            ? () => launchUrl(
                                Uri.parse('mailto:${employee.workEmail}'),
                              )
                            : null,
                        icon: const Icon(Icons.email),
                        label: const Text("Email"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Work Info Section
            buildSection(
              title: "Work Details",
              items: [
                _infoTile(Icons.apartment, "Division", employee.divisionName),
                _infoTile(
                  Icons.work_outline,
                  "Department",
                  employee.departmentName,
                ),
                _infoTile(
                  Icons.business_center,
                  "Designation",
                  employee.designationName,
                ),
              ],
            ),

            // Contact Section
            buildSection(
              title: "Contact Information",
              items: [
                _infoTile(Icons.phone_android, "Mobile", employee.workMobile),
                _infoTile(Icons.email_rounded, "Email", employee.workEmail),
              ],
            ),

            // Supervisor Info
            buildSection(
              title: "Supervisor Info",
              items: [
                _infoTile(
                  Icons.person,
                  "Supervisor",
                  employee.supervisorFullName,
                ),
                _contactTile(
                  Icons.email,
                  "Email",
                  employee.supervisorEmail,
                  "mailto:${employee.supervisorEmail}",
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildSection({required String title, required List<Widget> items}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          ...items,
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.red.shade400),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$label: ${value ?? '-'}",
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactTile(
    IconData icon,
    String label,
    String? value,
    String actionUrl,
  ) {
    return InkWell(
      onTap: value != null && value.isNotEmpty
          ? () async {
              final uri = Uri.parse(actionUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: Colors.red.shade400),
            const SizedBox(width: 10),
            Expanded(
              child: Row(
                children: [
                  Text("$label: "),
                  Text(
                    value ?? '-',
                    style: TextStyle(
                      fontSize: 15,
                      color: value != null && value.isNotEmpty
                          ? Colors.blueAccent
                          : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
