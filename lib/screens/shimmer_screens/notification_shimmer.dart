import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NotificationShimmer extends StatelessWidget {
  const NotificationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        itemCount: 6, // number of shimmer placeholders
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              ),
              title: Container(
                height: 14,
                width: double.infinity,
                color: Colors.grey.shade300,
                margin: const EdgeInsets.only(bottom: 6),
              ),
              subtitle: Container(
                height: 12,
                width: 120,
                color: Colors.grey.shade300,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
