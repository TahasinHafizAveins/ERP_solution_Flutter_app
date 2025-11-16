import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EmployeeDirShimmer extends StatelessWidget {
  final int itemCount;
  const EmployeeDirShimmer({super.key, this.itemCount = 10});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            // List shimmer
            Expanded(
              child: ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.red[200]!,
                    highlightColor: Colors.red[50]!,
                    child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            // Profile image placeholder
                            Container(
                              width: 60,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 14),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
