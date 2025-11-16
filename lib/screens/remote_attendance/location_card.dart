import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  final VoidCallback? onGetLocation;
  final double? latitude;
  final double? longitude;
  final bool isLocating;
  final VoidCallback? onClearLocation;

  const LocationCard({
    super.key,
    this.onGetLocation,
    this.onClearLocation,
    this.latitude,
    this.longitude,
    required this.isLocating,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryRed = const Color(0xFFD32F2F);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Current Location",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (latitude != null && longitude != null)
            Text(
              "📍 $latitude, $longitude",
              style: const TextStyle(color: Colors.black87),
            )
          else
            const Text(
              "No location selected",
              style: TextStyle(color: Colors.black45),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isLocating ? null : onGetLocation,
                  icon: isLocating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.gps_fixed, color: Colors.white),
                  label: const Text(
                    "Get Location",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: latitude != null ? onClearLocation : null,
                icon: const Icon(Icons.clear),
                color: primaryRed,
                style: IconButton.styleFrom(
                  backgroundColor: primaryRed.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
