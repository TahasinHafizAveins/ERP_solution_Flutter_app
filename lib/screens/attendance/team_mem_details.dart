import 'package:erp_solution/models/attendance_summery_result_model.dart';
import 'package:erp_solution/utils/team_member_list_item.dart';
import 'package:flutter/material.dart';

class TeamMemDetails extends StatefulWidget {
  final Result? teamMemDetails;
  const TeamMemDetails({super.key, this.teamMemDetails});

  @override
  State<TeamMemDetails> createState() => _TeamMemDetailsState();
}

class _TeamMemDetailsState extends State<TeamMemDetails> {
  @override
  Widget build(BuildContext context) {
    final teamDetailsList = widget.teamMemDetails?.table?.rows ?? [];
    String memberCount =
        widget.teamMemDetails?.table?.rows?.length.toString() ?? '0';
    return Container(
      padding: EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "$memberCount Members (Today's Attendance) ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: teamDetailsList.length,
              itemBuilder: (context, index) {
                return TeamMemberListItem(
                  teamDetail: teamDetailsList[index].cells ?? [],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
