import 'package:flutter/material.dart';

class AttendanceHeaderCard extends StatelessWidget {
  final formattedDate;
  final isCheckedIn;
  final checkInTime;

  const AttendanceHeaderCard({
    super.key,
    this.formattedDate,
    this.isCheckedIn,
    this.checkInTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)], // 🔴 Red gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header title section
          Text(
            "Remote Attendance",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isCheckedIn
                ? "You checked in at ${checkInTime?.hour}:${checkInTime?.minute.toString().padLeft(2, '0')}"
                : "Mark your attendance from anywhere",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 14),

          // 🔹 Date Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                  SizedBox(width: 6),
                  Text(
                    "Today",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
              Text(
                formattedDate,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 🔹 Status row (newly merged from your second version)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.access_time, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isCheckedIn ? "✅ Checked In — Active" : "⏱ Ready to check in",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
