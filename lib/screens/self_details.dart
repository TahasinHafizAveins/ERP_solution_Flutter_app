import 'package:erp_solution/models/attendance_summery_result_model.dart';
import 'package:erp_solution/utils/self_item_widget.dart';
import 'package:flutter/material.dart';

class SelfDetails extends StatefulWidget {
  final Result? selfDetails;

  const SelfDetails({super.key, required this.selfDetails});

  @override
  State<SelfDetails> createState() => _SelfDetailsState();
}

class _SelfDetailsState extends State<SelfDetails> {
  @override
  Widget build(BuildContext context) {
    final selfDetailsList = widget.selfDetails?.table?.rows ?? [];

    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              widget.selfDetails?.title ?? 'No details available',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: selfDetailsList.length,
              itemBuilder: (context, index) {
                final item = selfDetailsList[index].cells ?? [];
                return SelfItemWidget(selfDetail: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}
