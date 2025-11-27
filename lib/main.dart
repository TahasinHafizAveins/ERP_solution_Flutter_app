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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      // Routes for navigation
      routes: {
        '/login': (context) => const Login(),
        '/home': (context) => const Home(),
        '/selected_member_details': (context) => const SelectedMemberDetails(),
        '/employee_details': (context) => const EmployeeDetails(),
        '/notifications': (context) => const Notifications(),
      },
      // Initial screen: use Consumer to decide
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
                // Using a boolean to prevent multiple connections
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final signalRService = SignalRNotificationService();
                  if (!signalRService.isConnected &&
                      !signalRService.isConnecting) {
                    signalRService.startConnection(token);
                  }
                });
                return const Home();
              } else {
                // Stop SignalR when user logs out
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  SignalRNotificationService().stopConnection();
                });
                return const Login();
              }
              //return const Home();
            },
          );
        },
      ),
    );
  }
}
