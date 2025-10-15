import 'package:cached_network_image/cached_network_image.dart';
import 'package:erp_solution/models/employee_dir_model.dart';
import 'package:erp_solution/utils/api_end_points.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EmployeeDirItem extends StatelessWidget {
  final EmployeeDirModel employeeDetails;

  const EmployeeDirItem({super.key, required this.employeeDetails});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.red.shade100, Colors.red.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Profile Image
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red.shade300, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl:
                      (employeeDetails.imagePath != null &&
                          employeeDetails.imagePath!.isNotEmpty)
                      ? "${ApiEndPoints.base}${ApiEndPoints.imageApi}${employeeDetails.imagePath}"
                      : "https://cdn-icons-png.flaticon.com/512/149/149071.png",
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,

                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  errorWidget: (context, error, stackTrace) =>
                      const Icon(Icons.person, size: 40, color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Employee Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employeeDetails.fullName ?? "-",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    employeeDetails.designationName ?? "-",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.badge, size: 16, color: Colors.red.shade800),
                      const SizedBox(width: 4),
                      Text(
                        employeeDetails.employeeCode?.toString() ?? "-",
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.phone, size: 16, color: Colors.red.shade800),
                      const SizedBox(width: 4),
                      Text(
                        employeeDetails.workMobile ?? "-",
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Optional arrow for navigation feel
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.red[800],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
