import 'package:erp_solution/models/country_model.dart';
import 'package:erp_solution/provider/remote_attendance_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ManualLocationSelector extends StatefulWidget {
  const ManualLocationSelector({super.key});

  @override
  State<ManualLocationSelector> createState() => _ManualLocationSelectorState();
}

class _ManualLocationSelectorState extends State<ManualLocationSelector> {
  @override
  Widget build(BuildContext context) {
    final redColor = Colors.redAccent.shade400;
    return Consumer<RemoteAttendanceProvider>(
      builder: (context, provider, _) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              provider.isLoading
                  ? _buildShimmerDropdown()
                  : _buildDropdown(
                      "Division",
                      redColor,
                      provider.divisions,
                      provider.selectedDivision,
                      (value) {
                        final div = provider.divisions.firstWhere(
                          (d) => d.label == value,
                          orElse: () => CountryModel(),
                        );
                        provider.selectDivision(div);
                      },
                    ),
              const SizedBox(height: 14),
              provider.isLoading
                  ? _buildShimmerDropdown()
                  : _buildDropdown(
                      "District",
                      redColor,
                      provider.districts,
                      provider.selectedDistrict,
                      (value) {
                        final dist = provider.districts.firstWhere(
                          (d) => d.label == value,
                          orElse: () => CountryModel(),
                        );
                        provider.selectDistrict(dist);
                      },
                    ),
              const SizedBox(height: 14),
              provider.isLoading
                  ? _buildShimmerDropdown()
                  : _buildDropdown(
                      "Thana",
                      redColor,
                      provider.thana,
                      provider.selectedThana,
                      (value) {
                        final thana = provider.thana.firstWhere(
                          (d) => d.label == value,
                          orElse: () => CountryModel(),
                        );
                        provider.selectThana(thana);
                      },
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdown(
    String label,
    Color accentColor,
    List<CountryModel> dropdownItems,
    CountryModel? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: selectedValue?.label,
      isExpanded: true, // 👈 Ensures full-width layout and prevents cutoff
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: accentColor, fontWeight: FontWeight.w500),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: accentColor, width: 1.6),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      icon: Icon(Icons.keyboard_arrow_down_rounded, color: accentColor),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(16),
      menuMaxHeight: 220,
      items: dropdownItems.map((e) {
        return DropdownMenuItem<String>(
          value: e.label,
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: accentColor.withOpacity(0.8),
              ),
              const SizedBox(width: 8),
              Flexible(
                // 👈 Prevents overflow or truncation
                child: Text(
                  e.label ?? '',
                  overflow:
                      TextOverflow.ellipsis, // gracefully truncate if long
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  ///  Reusable shimmer placeholder
  Widget _buildShimmerDropdown() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
