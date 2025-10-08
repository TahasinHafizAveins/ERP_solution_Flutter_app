import 'package:cached_network_image/cached_network_image.dart';
import 'package:erp_solution/models/attendance_summery_model.dart';
import 'package:erp_solution/models/attendance_summery_result_model.dart';
import 'package:erp_solution/utils/api_end_points.dart';
import 'package:erp_solution/utils/common_utils.dart';
import 'package:erp_solution/utils/self_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../provider/team_mem_attendance_details_provider.dart';

class SelectedMemberDetails extends StatefulWidget {
  const SelectedMemberDetails({super.key});

  @override
  State<SelectedMemberDetails> createState() => _SelectedMemberDetailsState();
}

class _SelectedMemberDetailsState extends State<SelectedMemberDetails> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String userId = args['id'] as String;

    final provider = Provider.of<TeamMemAttendanceDetailsProvider>(
      context,
      listen: false,
    );
    provider.loadTeamAttendanceDetails(userId);
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final List<Cells> teamDetail = args['teamDetail'] as List<Cells>;

    final String name = CommonUtils.getValue(teamDetail, "FullName");
    final String id = CommonUtils.getValue(teamDetail, "id");
    final String designation = CommonUtils.getValue(
      teamDetail,
      "DesignationName",
    );
    final String imageUrl =
        "${ApiEndPoints.base}${ApiEndPoints.imageApi}${CommonUtils.getValue(teamDetail, "avatar")}"; // Placeholder image path

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$name\'s Attendance Details',
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
        backgroundColor: Colors.grey[300],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(90),
                  bottomRight: Radius.circular(90),
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
                                          height: 300,
                                          width: double.infinity,
                                          color: Colors.white,
                                        ),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                        Icons.error,
                                        size: 100,
                                        color: Colors.white,
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
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Name
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Employee Code
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        designation,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),

            const SizedBox(height: 20),
            // Attendance Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              child: const Text(
                "Attendance (Last 30 Days)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            Consumer<TeamMemAttendanceDetailsProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.error != null) {
                  return Center(child: Text('Error: ${provider.error}'));
                }
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: getItemCount(provider.summery),
                    itemBuilder: (context, index) {
                      final item = getItemValues(provider.summery, index);
                      return SelfItemWidget(selfDetail: item);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  int? getItemCount(AttendanceSummeryModel? summery) {
    final summeryModel = summery?.result?.firstWhere(
      (result) => result.id == 'widget10',
    );
    return summeryModel?.table?.rows?.length;
  }

  getItemValues(AttendanceSummeryModel? summery, int index) {
    final summeryModel = summery?.result?.firstWhere(
      (result) => result.id == 'widget10',
    );
    return summeryModel?.table?.rows?[index].cells;
  }
}
