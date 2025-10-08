import 'package:cached_network_image/cached_network_image.dart';
import 'package:erp_solution/models/attendance_summery_result_model.dart';
import 'package:erp_solution/utils/api_end_points.dart';
import 'package:erp_solution/utils/color_widget.dart';
import 'package:erp_solution/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TeamMemberListItem extends StatelessWidget {
  final List<Cells> teamDetail;
  const TeamMemberListItem({super.key, required this.teamDetail});

  @override
  Widget build(BuildContext context) {
    // Extract values using helper
    final String name = CommonUtils.getValue(teamDetail, "FullName");
    final String designation = CommonUtils.getValue(
      teamDetail,
      "DesignationName",
    );
    final String status = CommonUtils.getValue(teamDetail, "ATTENDANCE_STATUS");
    final String inTime = CommonUtils.getValue(teamDetail, "IN_TIME");
    final String outTime = CommonUtils.getValue(teamDetail, "OUT_TIME");
    final String imageUrl =
        "${ApiEndPoints.base}${ApiEndPoints.imageApi}${CommonUtils.getValue(teamDetail, "avatar")}"; // Placeholder image path

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              ColorWidget.getStatusColor(status),
              ColorWidget.getStatusColor(status),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            // Profile Image
            ClipOval(
              child: Container(
                width: 60,
                height: 60,
                color: Colors.transparent, // fallback background
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain, // keeps the full image inside circle
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  errorWidget: (context, error, stackTrace) {
                    return const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Info Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    designation,
                    style: const TextStyle(fontSize: 15, color: Colors.white70),
                  ),
                  const SizedBox(height: 6),

                  // In-Time & Out-Time (only if Present/Late)
                  if (status.toLowerCase() != "absent")
                    Row(
                      children: [
                        Icon(Icons.login, color: Colors.white, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          "In: $inTime",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.logout, color: Colors.white, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          "Out: $outTime",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
