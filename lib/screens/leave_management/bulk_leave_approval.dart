import 'package:erp_solution/provider/leave_management_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/bulk_approva_iItem_model.dart';
import '../../models/pending_bulk_leave_application_model.dart';

class BulkLeaveApprovalPage extends StatefulWidget {
  const BulkLeaveApprovalPage({super.key});

  @override
  State<BulkLeaveApprovalPage> createState() => _BulkLeaveApprovalPageState();
}

class _BulkLeaveApprovalPageState extends State<BulkLeaveApprovalPage> {
  final Map<int, bool> _selectedApplications = {};
  final Map<int, String> _approvalStatus = {};
  final Map<int, TextEditingController> _commentControllers = {};
  final TextEditingController _bulkCommentController = TextEditingController();
  bool _useBulkComment = true;
  String _bulkAction = 'approve';
  bool _selectAll = false;
  bool _expandedSettings = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<LeaveManagementProvider>(
        context,
        listen: false,
      );
      provider.loadPendingApplications();
    });
  }

  @override
  void dispose() {
    _bulkCommentController.dispose();
    _commentControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  int _getSelectedCount() {
    return _selectedApplications.values.where((selected) => selected).length;
  }

  void _toggleSelectAll(bool? value) {
    if (value == null) return;

    setState(() {
      _selectAll = value;
      final provider = Provider.of<LeaveManagementProvider>(
        context,
        listen: false,
      );

      for (var app in provider.pendingApplications) {
        final appId = app.employeeLeaveAID;
        _selectedApplications[appId] = value;
        if (!value) {
          _approvalStatus.remove(appId);
        }
      }
    });
  }

  BulkApprovalPayload _createBulkPayload() {
    final provider = Provider.of<LeaveManagementProvider>(
      context,
      listen: false,
    );

    final items = provider.pendingApplications
        .where((app) {
          final isSelected =
              _selectedApplications[app.employeeLeaveAID] ?? false;
          final status = _approvalStatus[app.employeeLeaveAID] ?? _bulkAction;
          return isSelected && status.isNotEmpty;
        })
        .map((app) {
          final appId = app.employeeLeaveAID;
          final status = _approvalStatus[appId] ?? _bulkAction;
          final comment = _useBulkComment
              ? _bulkCommentController.text.trim()
              : _commentControllers[appId]?.text.trim() ?? '';

          return BulkApprovalItem(
            employeeLeaveAID: appId,
            approvalProcessID: app.approvalProcessID,
            apEmployeeFeedbackID: app.apEmployeeFeedbackID,
            referenceID: appId,
            approvalType: status == 'approve' ? 'Approve' : 'Reject',
            apFeedbackID: status == 'approve' ? 5 : 6,
            comment: comment,
          );
        })
        .toList();

    return BulkApprovalPayload(bulkList: items);
  }

  Future<void> _showConfirmationDialog() async {
    final selectedCount = _getSelectedCount();
    if (selectedCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least one application'),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    final payload = _createBulkPayload();
    if (payload.bulkList.isEmpty) return;

    final approveCount = payload.bulkList
        .where((item) => item.approvalType == 'Approve')
        .length;
    final rejectCount = payload.bulkList
        .where((item) => item.approvalType == 'Reject')
        .length;

    bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.playlist_add_check_rounded,
                color: Colors.red.shade700,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Process $selectedCount Application${selectedCount > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You\'re about to ${approveCount > 0 && rejectCount == 0
                  ? 'approve'
                  : approveCount == 0 && rejectCount > 0
                  ? 'reject'
                  : 'process'} $selectedCount leave application${selectedCount > 1 ? 's' : ''}',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            if (approveCount > 0)
              _buildStatusBadge('Approve', approveCount, Colors.green),
            if (rejectCount > 0 && approveCount > 0) const SizedBox(height: 8),
            if (rejectCount > 0)
              _buildStatusBadge('Reject', rejectCount, Colors.red),
            if (_useBulkComment && _bulkCommentController.text.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Comment:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _bulkCommentController.text,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _submitBulkApproval(payload);
    }
  }

  Widget _buildStatusBadge(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(
                label == 'Approve' ? Icons.check : Icons.close,
                size: 14,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(
                '$label: $count',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _submitBulkApproval(BulkApprovalPayload payload) async {
    final provider = Provider.of<LeaveManagementProvider>(
      context,
      listen: false,
    );

    final success = await provider.submitBulkLeaveApproval(payload);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Successfully processed ${payload.bulkList.length} application(s)',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          duration: const Duration(seconds: 2),
        ),
      );

      _selectedApplications.clear();
      _commentControllers.clear();
      _bulkCommentController.clear();
      _selectAll = false;

      await provider.loadPendingApplications();

      if (provider.pendingApplications.isEmpty && mounted) {
        Navigator.pop(context);
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            provider.bulkApprovalError ?? 'Failed to process applications',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  Widget _buildApplicationCard(PendingLeaveApplication application) {
    final isSelected =
        _selectedApplications[application.employeeLeaveAID] ?? false;
    final individualStatus = _approvalStatus[application.employeeLeaveAID];
    final isIndividualMode = !_useBulkComment || individualStatus != null;

    if (!_commentControllers.containsKey(application.employeeLeaveAID)) {
      _commentControllers[application.employeeLeaveAID] =
          TextEditingController();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.red.shade200 : Colors.grey.shade200,
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSelected ? 0.08 : 0.04),
            blurRadius: isSelected ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      _selectedApplications[application.employeeLeaveAID] =
                          value ?? false;
                      if (!(value ?? false)) {
                        _approvalStatus.remove(application.employeeLeaveAID);
                      }
                    });
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  activeColor: Colors.red.shade700,
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.red.shade100,
                  child: Text(
                    _getInitials(application.employeeName),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              application.employeeName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isSelected && isIndividualMode)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    (individualStatus ?? _bulkAction) ==
                                        'approve'
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    (individualStatus ?? _bulkAction) ==
                                            'approve'
                                        ? Icons.check
                                        : Icons.close,
                                    size: 10,
                                    color:
                                        (individualStatus ?? _bulkAction) ==
                                            'approve'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    (individualStatus ?? _bulkAction) ==
                                            'approve'
                                        ? 'Approve'
                                        : 'Reject',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          (individualStatus ?? _bulkAction) ==
                                              'approve'
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        application.employeeCode,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildCompactDetailRow(
                        Icons.work_outline,
                        application.leaveCategory,
                      ),
                      _buildCompactDetailRow(
                        Icons.calendar_today,
                        application.leaveDates,
                      ),
                      _buildCompactDetailRow(
                        Icons.access_time,
                        '${application.numberOfLeave} day(s)',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Actions (only if selected)
          if (isSelected) ...[
            Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _approvalStatus[application.employeeLeaveAID] =
                                  'approve';
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            side: BorderSide(
                              color: (individualStatus ?? '') == 'approve'
                                  ? Colors.green
                                  : Colors.green.shade300,
                            ),
                            backgroundColor:
                                (individualStatus ?? '') == 'approve'
                                ? Colors.green.withOpacity(0.1)
                                : Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: Icon(
                            Icons.check,
                            size: 16,
                            color: (individualStatus ?? '') == 'approve'
                                ? Colors.green
                                : Colors.green.shade400,
                          ),
                          label: Text(
                            'Approve',
                            style: TextStyle(
                              fontWeight: (individualStatus ?? '') == 'approve'
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _approvalStatus[application.employeeLeaveAID] =
                                  'reject';
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: BorderSide(
                              color: (individualStatus ?? '') == 'reject'
                                  ? Colors.red
                                  : Colors.red.shade300,
                            ),
                            backgroundColor:
                                (individualStatus ?? '') == 'reject'
                                ? Colors.red.withOpacity(0.1)
                                : Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: Icon(
                            Icons.close,
                            size: 16,
                            color: (individualStatus ?? '') == 'reject'
                                ? Colors.red
                                : Colors.red.shade400,
                          ),
                          label: Text(
                            'Reject',
                            style: TextStyle(
                              fontWeight: (individualStatus ?? '') == 'reject'
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!_useBulkComment || individualStatus != null) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller:
                          _commentControllers[application.employeeLeaveAID],
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Add comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'TM';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.length >= 2
        ? name.substring(0, 2).toUpperCase()
        : name.toUpperCase();
  }

  Widget _buildCompactDetailRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade500),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: 12,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  for (int i = 0; i < 3; i++) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 12,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String error, LeaveManagementProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Unable to Load',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => provider.loadPendingApplications(),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 50,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'All Clear!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No pending leave applications\nawaiting your approval.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
              ),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bulk Approval',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
        ),
      ),
      body: Consumer<LeaveManagementProvider>(
        builder: (context, provider, child) {
          if (provider.isPendingApplicationsLoading) {
            return _buildLoadingState();
          }

          if (provider.pendingApplicationsError != null) {
            return _buildErrorState(
              provider.pendingApplicationsError!,
              provider,
            );
          }

          final pendingApplications = provider.pendingApplications;
          if (pendingApplications.isEmpty) {
            return _buildEmptyState();
          }

          final selectedCount = _getSelectedCount();
          final totalCount = pendingApplications.length;

          return Column(
            children: [
              // Control Panel
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Selection Bar
                      Row(
                        children: [
                          Checkbox(
                            value: _selectAll,
                            onChanged: _toggleSelectAll,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            activeColor: Colors.red.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Select All',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$selectedCount selected',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: selectedCount > 0
                                  ? Colors.red.shade700
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Settings Toggle
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _expandedSettings = !_expandedSettings;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _expandedSettings
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 18,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Settings',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  _bulkAction == 'approve'
                                      ? 'Approve'
                                      : 'Reject',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _bulkAction == 'approve'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Settings Content
                      if (_expandedSettings) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Default Action',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  DropdownButtonFormField<String>(
                                    value: _bulkAction,
                                    items: [
                                      DropdownMenuItem(
                                        value: 'approve',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.green,
                                            ),
                                            const SizedBox(width: 8),
                                            const Text('Approve'),
                                          ],
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'reject',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.close,
                                              size: 16,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(width: 8),
                                            const Text('Reject'),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _bulkAction = value ?? 'approve';
                                      });
                                    },
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Comment Mode',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  DropdownButtonFormField<bool>(
                                    value: _useBulkComment,
                                    items: const [
                                      DropdownMenuItem(
                                        value: true,
                                        child: Text('Bulk'),
                                      ),
                                      DropdownMenuItem(
                                        value: false,
                                        child: Text('Individual'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _useBulkComment = value ?? true;
                                      });
                                    },
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (_useBulkComment) ...[
                          const SizedBox(height: 12),
                          TextField(
                            controller: _bulkCommentController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: 'Add bulk comment...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                      ],

                      // Action Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed:
                              selectedCount == 0 ||
                                  provider.isBulkApprovalLoading
                              ? null
                              : _showConfirmationDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedCount == 0
                                ? Colors.grey.shade300
                                : Colors.red.shade700,
                            foregroundColor: selectedCount == 0
                                ? Colors.grey.shade500
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: provider.isBulkApprovalLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  Icons.send,
                                  size: 18,
                                  color: selectedCount == 0
                                      ? Colors.grey.shade500
                                      : Colors.white,
                                ),
                          label: Text(
                            provider.isBulkApprovalLoading
                                ? 'Processing...'
                                : 'Process $selectedCount Selected',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Applications List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: pendingApplications.length,
                  itemBuilder: (context, index) {
                    return _buildApplicationCard(pendingApplications[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
