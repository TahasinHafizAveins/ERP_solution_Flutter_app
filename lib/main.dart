import 'package:erp_solution/nav_screens/notifications.dart';
import 'package:erp_solution/provider/attendance_summery_provider.dart';
import 'package:erp_solution/provider/auth_provider.dart';
import 'package:erp_solution/provider/employee_dir_provider.dart';
import 'package:erp_solution/provider/leave_management_provider.dart';
import 'package:erp_solution/provider/notification_provider.dart';
import 'package:erp_solution/provider/remote_attendance_provider.dart';
import 'package:erp_solution/provider/team_mem_attendance_details_provider.dart';
import 'package:erp_solution/screens/employee_dir/employee_details.dart';
import 'package:erp_solution/screens/home.dart';
import 'package:erp_solution/screens/login.dart';
import 'package:erp_solution/screens/team_attendance/selected_member_details.dart';
import 'package:erp_solution/service/api_service.dart';
import 'package:erp_solution/service/attendance_summery_service.dart';
import 'package:erp_solution/service/auth_event_service.dart';
import 'package:erp_solution/service/auth_service.dart';
import 'package:erp_solution/service/employee_dir_service.dart';
import 'package:erp_solution/service/leave_management_service.dart';
import 'package:erp_solution/service/notification_service.dart';
import 'package:erp_solution/service/notifications_list_service.dart';
import 'package:erp_solution/service/remote_attendance_service.dart';
import 'package:erp_solution/service/signalr_notification_service.dart';
import 'package:erp_solution/service/team_mem_attendance_details_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apiService = ApiService();

  // Initialize API service
  await apiService.init();

  // Initialize notifications
  await NotificationService.init();
  NotificationService.onNotificationClick = () {
    navigatorKey.currentState?.pushNamed('/notifications');
  };

  // Initialize SignalR service as singleton
  await SignalRNotificationService().initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthService(apiService)),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              AttendanceSummeryProvider(AttendanceSummeryService(apiService)),
        ),
        ChangeNotifierProvider(
          create: (_) => EmployeeDirProvider(EmployeeDirService(apiService)),
        ),
        ChangeNotifierProvider(
          create: (_) => TeamMemAttendanceDetailsProvider(
            TeamMemAttendanceDetailsService(apiService),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              NotificationProvider(NotificationsListService(apiService)),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              RemoteAttendanceProvider(RemoteAttendanceService(apiService)),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              LeaveManagementProvider(LeaveManagementService(apiService)),
        ),
      ],
      child: const HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isHandlingTokenExpired = false;

  @override
  void initState() {
    super.initState();
    // Listen for token expiration
    AuthEventService().addTokenExpiredListener(_handleTokenExpired);
  }

  @override
  void dispose() {
    AuthEventService().removeTokenExpiredListener(_handleTokenExpired);
    super.dispose();
  }

  void _handleTokenExpired() {
    if (_isHandlingTokenExpired) return;

    _isHandlingTokenExpired = true;
    print("Handling token expiration...");

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final authProvider = context.read<AuthProvider>();

        // Force logout in provider - this will trigger rebuild
        await authProvider.forceLogout();

        // Stop SignalR connection
        SignalRNotificationService().stopConnection();

        // Clear all providers that might have user-specific data
        _clearAllProviders();

        // Show session expired message
        _showSessionExpiredMessage();
      } catch (e) {
        print("Error handling token expiration: $e");
      } finally {
        _isHandlingTokenExpired = false;
      }
    });
  }

  void _clearAllProviders() {
    // Clear data from all providers that might contain user-specific data
    try {
      final context = navigatorKey.currentContext;
      if (context != null) {
        // Example: Clear attendance data
        Provider.of<AttendanceSummeryProvider>(
          context,
          listen: false,
        ).clearData();
        Provider.of<NotificationProvider>(context, listen: false).clearData();
        // Add other providers as needed
      }
    } catch (e) {
      print("Error clearing providers: $e");
    }
  }

  void _showSessionExpiredMessage() {
    final context = navigatorKey.currentContext;
    if (context != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your session has expired. Please login again.'),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      routes: {
        '/login': (context) => const Login(),
        '/home': (context) => const Home(),
        '/selected_member_details': (context) => const SelectedMemberDetails(),
        '/employee_details': (context) => const EmployeeDetails(),
        '/notifications': (context) => const Notifications(),
      },
      home: FutureBuilder(
        future: context.read<AuthProvider>().init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Consumer<AuthProvider>(
            builder: (context, auth, _) {
              if (auth.isLoggedIn) {
                final token = auth.authToken ?? "";
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final signalRService = SignalRNotificationService();
                  if (!signalRService.isConnected &&
                      !signalRService.isConnecting) {
                    signalRService.startConnection(token);
                  }
                });
                return const Home();
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  SignalRNotificationService().stopConnection();
                });
                return const Login();
              }
            },
          );
        },
      ),
    );
  }
}
