import 'package:erp_solution/provider/leave_management_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class LeaveApplicationDetails extends StatefulWidget {
  final int type;
  final int ref;
  final String originateFrom;
  const LeaveApplicationDetails({
    super.key,
    required this.type,
    required this.ref,
    required this.originateFrom,
  });

  @override
  State<LeaveApplicationDetails> createState() =>
      _LeaveApplicationDetailsState();
}

class _LeaveApplicationDetailsState extends State<LeaveApplicationDetails> {
  late Future<void> _loadDataFuture;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _loadData();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final provider = Provider.of<LeaveManagementProvider>(
      context,
      listen: false,
    );
    await provider.getLeaveApplicationDetails(
      type: widget.type,
      ref: widget.ref,
    );
  }

  void _handleApprove(List<dynamic> details) {
    _showCommentDialog('Approve', Colors.green, details);
  }

  void _handleReject(List<dynamic> details) {
    _showCommentDialog('Reject', Colors.red, details);
  }

  void _showCommentDialog(String action, Color color, List<dynamic> details) {
    _commentController.clear();
    bool isCommentValid = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(
                  action == 'Approve' ? Icons.check_circle : Icons.cancel,
                  color: color,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  '$action Leave Application',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please provide a comment for your decision:',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _commentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter your comment here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: color, width: 2),
                    ),
                    errorText: isCommentValid ? null : 'Comment is required',
                    errorStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      isCommentValid = value.trim().isNotEmpty;
                    });
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  '* Comment is mandatory',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey.shade600,
                ),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _commentController.text.trim().isNotEmpty
                    ? () {
                        final comment = _commentController.text.trim();
                        Navigator.pop(context);
                        _callApproveRejectAPI(action, comment, details);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Submit $action'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _callApproveRejectAPI(
    String action,
    String comment,
    List<dynamic> details,
  ) async {
    if (details.length > 1) {
      final currentApprover = details[1];
      final approvalProcessID = currentApprover['ApprovalProcessID'];
      final apEmployeeFeedbackID = currentApprover['APEmployeeFeedbackID'];
      final apFeedbackID = action == 'Approve'
          ? 5
          : 6; // 5 for Approve, 4 for Reject
      final apTypeID = currentApprover['APTypeID'];
      final referenceID = currentApprover['ReferenceID'];

      final payload = {
        "ApprovalProcessID": approvalProcessID,
        "APEmployeeFeedbackID": apEmployeeFeedbackID,
        "APFeedbackID": apFeedbackID,
        "Remarks": comment,
        "APTypeID": apTypeID,
        "ReferenceID": referenceID,
        "ToAPMemberFeedbackID": 0,
        "APForwardInfoID": 0,
      };

      try {
        final provider = Provider.of<LeaveManagementProvider>(
          context,
          listen: false,
        );

        final bool success = await provider.submitLeaveApproval(payload);

        if (success) {
          _showSuccessSnackbar(action, comment);

          // Refresh the details data
          setState(() {
            _loadDataFuture = _loadData();
          });
        } else {
          // Show error from provider
          final error =
              provider.submitLeaveApprovalError ?? 'Unknown error occurred';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Failed to $action: $error'),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to $action: $e'),
          ),
        );
      }
    }
  }

  void _showSuccessSnackbar(String action, String comment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: action == 'Approve' ? Colors.green : Colors.red,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  action == 'Approve' ? Icons.check_circle : Icons.cancel,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Text(
                  'Leave application ${action.toLowerCase()}d successfully!',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            if (comment.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Comment: $comment',
                style: const TextStyle(fontSize: 12, color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Check if current user can approve/reject (application is still pending)
  bool _canTakeAction(List<dynamic> details) {
    if (widget.originateFrom != "TeamLeaveApplication") return false;

    // Check if application is already rejected (based on index 1)
    if (_isApplicationRejected(details)) {
      return false;
    }

    // Check only index 1 for pending status (Feedback Requested or Not Yet Requested)
    if (details.length > 1) {
      final feedback =
          details[1]['APFeedbackName']?.toString().toLowerCase() ?? '';
      if (feedback == 'feedback requested' || feedback == 'not yet requested') {
        return true;
      }
    }
    return false;
  }

  // Check if application is already rejected (based on index 1)
  bool _isApplicationRejected(List<dynamic> details) {
    if (details.length > 1) {
      final feedback =
          details[1]['APFeedbackName']?.toString().toLowerCase() ?? '';
      return feedback == 'rejected';
    }
    return false;
  }

  // Check if application is already approved (based on index 1)
  bool _isApplicationApproved(List<dynamic> details) {
    if (details.length > 1) {
      final feedback =
          details[1]['APFeedbackName']?.toString().toLowerCase() ?? '';
      return feedback == 'approved';
    }
    return false;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'feedback requested':
        return Colors.orange;
      case 'not yet requested':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green.shade50;
      case 'rejected':
        return Colors.red.shade50;
      case 'feedback requested':
        return Colors.orange.shade50;
      case 'not yet requested':
        return Colors.grey.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      case 'feedback requested':
        return Icons.pending_actions_rounded;
      case 'not yet requested':
        return Icons.schedule_rounded;
      default:
        return Icons.help_rounded;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'feedback requested':
        return 'Pending';
      case 'not yet requested':
        return 'Not Yet Requested';
      default:
        return status;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Not Responded';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return 'Not Responded';
    }
  }

  String _parseEmployeeInfo(String title) {
    try {
      final parts = title.split(', ');
      if (parts.length >= 2) {
        return parts[1];
      }
    } catch (e) {}
    return title;
  }

  String _parseLeaveInfo(String title) {
    try {
      final parts = title.split(', ');
      if (parts.length >= 3) {
        return parts[2];
      }
    } catch (e) {}
    return '';
  }

  Widget _buildEmployeeAvatar(String? imagePath, String employeeName) {
    if (imagePath != null && imagePath.isNotEmpty) {
      final formattedPath = imagePath.replaceAll('\\', '/');
      return CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(formattedPath),
        onBackgroundImageError: (exception, stackTrace) {},
        child: _buildInitialsFallback(employeeName),
      );
    }

    return _buildInitialsAvatar(employeeName);
  }

  Widget _buildInitialsAvatar(String employeeName) {
    final initials = employeeName.isNotEmpty
        ? employeeName
              .split(' ')
              .map((e) => e.isNotEmpty ? e[0] : '')
              .take(2)
              .join()
        : 'TM';

    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.red.shade100,
      child: Text(
        initials,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.red.shade700,
        ),
      ),
    );
  }

  Widget _buildInitialsFallback(String employeeName) {
    final initials = employeeName.isNotEmpty
        ? employeeName
              .split(' ')
              .map((e) => e.isNotEmpty ? e[0] : '')
              .take(2)
              .join()
        : 'TM';

    return Text(
      initials,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Leave Application Details',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red.shade700,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red.shade50, Colors.grey.shade50],
          ),
        ),
        child: FutureBuilder(
          future: _loadDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }

            return Consumer<LeaveManagementProvider>(
              builder: (context, provider, child) {
                if (provider.isLeaveApplicationDetailsLoading) {
                  return _buildLoadingState();
                }

                if (provider.leaveApplicationDetailsError != null) {
                  return _buildErrorState(
                    provider.leaveApplicationDetailsError!,
                    provider,
                  );
                }

                final details = provider.leaveApplicationDetails;
                if (details.isEmpty) {
                  return _buildEmptyState();
                }

                final firstItem = details.first;
                final referenceId = firstItem['ReferenceID'] as int?;
                if (referenceId != widget.ref) {
                  return _buildLoadingState();
                }

                return _buildDetailsContent(details);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Shimmer Header Card
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              height: 140,
            ),
          ),

          // Shimmer Approval Cards
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildShimmerCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 18,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          height: 28,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 14,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error, LeaveManagementProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 80,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 20),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              error,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _loadDataFuture = _loadData();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(fontWeight: FontWeight.w600),
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.description_rounded,
                size: 60,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Details Found',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Unable to load leave application details.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsContent(List<dynamic> details) {
    final firstItem = details.first;
    final title = firstItem['APTitle'] ?? 'Leave Application';
    final employeeInfo = _parseEmployeeInfo(title);
    final leaveInfo = _parseLeaveInfo(title);
    final canTakeAction = _canTakeAction(details);
    final isRejected = _isApplicationRejected(details);
    final isApproved = _isApplicationApproved(details);

    return Column(
      children: [
        // Header Card with Gradient
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade600, Colors.red.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.red.shade300.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Application Info
              Row(
                children: [
                  Icon(
                    Icons.assignment_rounded,
                    color: Colors.white.withOpacity(0.9),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employeeInfo,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        if (leaveInfo.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            leaveInfo,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Application Status (if rejected or approved)
              if (isRejected || isApproved) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isRejected
                            ? Icons.cancel_rounded
                            : Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isRejected
                            ? 'Application Rejected'
                            : 'Application Approved',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Action Buttons (only show if not rejected and can take action)
              if (canTakeAction && !isRejected) ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _handleApprove(details);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          shadowColor: Colors.green.shade800,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_rounded, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Approve',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _handleReject(details);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.red.shade700,
                              width: 2,
                            ),
                          ),
                          elevation: 2,
                          shadowColor: Colors.red.shade800.withOpacity(0.3),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.close_rounded, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Reject',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ] else if (widget.originateFrom == "TeamLeaveApplication" &&
                  !isRejected &&
                  !isApproved) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.white.withOpacity(0.9),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'This application has been processed',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        // Approval Process List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: details.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = details[index];
              return _buildApprovalStepCard(item, index, details.length);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildApprovalStepCard(
    Map<String, dynamic> item,
    int index,
    int totalSteps,
  ) {
    final employeeName = item['EmployeeName'] ?? 'Unknown';
    final employeeCode = item['EmployeeCode'] ?? 'N/A';
    final feedback = item['APFeedbackName'] ?? 'Not Yet Requested';
    final requestDate = item['FeedbackRequestDate'];
    final responseDate = item['FeedbackLastResponseDate'];
    final submitDate = item['FeedbackSubmitDate'];
    final employeeImagePath = item['EmployeeImagePath'];
    final statusColor = _getStatusColor(feedback);
    final statusBackgroundColor = _getStatusBackgroundColor(feedback);
    final statusText = _getStatusText(feedback);

    // Hide status badge for index 0 (applicant)
    final showStatusBadge = index > 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: showStatusBadge
                ? _getStatusBorderColor(feedback)
                : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Employee Avatar
              _buildEmployeeAvatar(employeeImagePath, employeeName),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Employee Name and Status
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            employeeName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Status Badge (only show for index > 0)
                        if (showStatusBadge)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: statusBackgroundColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: statusColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getStatusIcon(feedback),
                                  size: 14,
                                  color: statusColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  statusText,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: statusColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Employee Code
                    Text(
                      'Code: $employeeCode',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Dates
                    _buildDateRow(
                      'Requested',
                      _formatDate(requestDate),
                      Icons.send_rounded,
                    ),
                    const SizedBox(height: 6),
                    _buildDateRow(
                      'Responded',
                      _formatDate(responseDate),
                      Icons.check_circle_rounded,
                    ),
                    const SizedBox(height: 6),
                    _buildDateRow(
                      'Submitted',
                      _formatDate(submitDate),
                      Icons.assignment_turned_in_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusBorderColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green.shade200;
      case 'rejected':
        return Colors.red.shade200;
      case 'feedback requested':
        return Colors.orange.shade200;
      case 'not yet requested':
        return Colors.grey.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  Widget _buildDateRow(String label, String value, IconData icon) {
    final isResponded = value != 'Not Responded';

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isResponded ? Colors.green.shade600 : Colors.grey.shade400,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 13,
                    color: isResponded
                        ? Colors.green.shade700
                        : Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
