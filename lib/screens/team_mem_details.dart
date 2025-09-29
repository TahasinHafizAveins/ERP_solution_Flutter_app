import 'package:erp_solution/models/attendance_summery_result_model.dart';
import 'package:flutter/material.dart';

class TeamMemDetails extends StatelessWidget {
  final Result? teamMemDetails;
  const TeamMemDetails({super.key, this.teamMemDetails});

  @override
  Widget build(BuildContext context) {
    String memberCount = teamMemDetails?.table?.rows?.length.toString() ?? '0';
    return Column(
      children: [
        Text(teamMemDetails?.title ?? 'No details available'),
        Text(memberCount),
      ],
    );
  }
}
