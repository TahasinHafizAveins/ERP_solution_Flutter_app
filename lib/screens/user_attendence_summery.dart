import 'package:erp_solution/provider/attendance_summery_provider.dart';
import 'package:erp_solution/screens/attendance_charts.dart';
import 'package:erp_solution/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAttendanceSummery extends StatefulWidget {
  const UserAttendanceSummery({super.key});

  @override
  State<UserAttendanceSummery> createState() => _UserAttendanceSummeryState();
}

class _UserAttendanceSummeryState extends State<UserAttendanceSummery> {
  int selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() => _fetchAttendanceSummery());
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> summaryDurations = {
      "LW": "Last Week",
      "L2W": "Last 2 Weeks",
      "L1M": "Last 30 Days",
    };
    return Consumer<AttendanceSummeryProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.error != null) {
          return Center(child: Text('Error: ${provider.error}'));
        }
        if (provider.summery == null) {
          return const Center(child: Text('No data available'));
        }
        final summery = provider.summery!;

        // convert keys and values into lists (to access by index)
        final keys = summaryDurations.keys.toList(); // ["LW", "L2W", "L1M"]
        final values = summaryDurations.values.toList(); // ["Last Week", ...]

        return Column(
          children: [
            Container(
              height: 85.0,
              padding: const EdgeInsets.fromLTRB(10.0, 16.0, 10.0, 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(summaryDurations.length, (index) {
                  final isSelected = index == selectedIndex;
                  return SizedBox(
                    height: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndex = index;
                          //_fetchAttendanceSummery();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? Colors.black
                            : Colors.grey,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: Text(
                        values[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  );
                }).withSpacing(8.0),
              ),
            ),
            Expanded(
              child: AttendanceCharts(
                selectedDuration: keys[selectedIndex],
                summery: summery,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchAttendanceSummery() async {
    final provider = Provider.of<AttendanceSummeryProvider>(
      context,
      listen: false,
    );
    provider.loadAttendanceSummery();
  }
}
