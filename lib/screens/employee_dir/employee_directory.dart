import 'package:erp_solution/provider/employee_dir_provider.dart';
import 'package:erp_solution/screens/employee_dir/employee_dir_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shimmer_screens/employee_dir_shimmer.dart';

class EmployeeDirectory extends StatefulWidget {
  const EmployeeDirectory({super.key});

  @override
  State<EmployeeDirectory> createState() => _EmployeeDirectoryState();
}

class _EmployeeDirectoryState extends State<EmployeeDirectory> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<EmployeeDirProvider>(context, listen: false);
      if (provider.employees.isEmpty && !provider.isLoading) {
        provider.loadEmployeeDir();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeDirProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const EmployeeDirShimmer();
        }
        if (provider.error != null) {
          return Center(child: Text('Error: ${provider.error}'));
        }
        if (provider.employees.isEmpty) {
          return const Center(child: Text('No employees found'));
        }

        // Filter employees based on search query
        final filteredEmployees = provider.employees.where((employee) {
          final name = employee.fullName?.toLowerCase() ?? '';
          final designation = employee.designationName?.toLowerCase() ?? '';
          final code = employee.employeeCode?.toLowerCase() ?? '';
          return name.contains(_searchQuery) ||
              designation.contains(_searchQuery) ||
              code.contains(_searchQuery);
        }).toList();

        return Container(
          padding: EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Employee Directory (${provider.employees.length} Members)",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              // Search bar with clear button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8,
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name, designation, or code',
                    prefixIcon: const Icon(Icons.search_sharp),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.red[50],
                    filled: true,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),

              const SizedBox(height: 10),

              // Employee list
              Expanded(
                child: filteredEmployees.isEmpty
                    ? const Center(child: Text("No matching employees found"))
                    : ListView.builder(
                        itemCount: filteredEmployees.length,
                        itemBuilder: (context, index) {
                          final employeeDetails = filteredEmployees[index];
                          return InkWell(
                            borderRadius: BorderRadius.circular(12),
                            splashColor: Colors.red.withOpacity(0.2),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/employee_details',
                                arguments: employeeDetails,
                              );
                            },
                            child: EmployeeDirItem(
                              employeeDetails: employeeDetails,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
