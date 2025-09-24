import 'package:erp_solution/provider/attendance_summery_provider.dart';
import 'package:erp_solution/provider/auth_provider.dart';
import 'package:erp_solution/screens/home.dart';
import 'package:erp_solution/screens/login.dart';
import 'package:erp_solution/service/api_service.dart';
import 'package:erp_solution/service/attendance_summery_service.dart';
import 'package:erp_solution/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apiService = ApiService();
  await apiService.init();

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
      // Routes for navigation
      routes: {
        '/login': (context) => const Login(),
        '/home': (context) => const Home(),
      },
      // Initial screen: use Consumer to decide
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return auth.isLoggedIn ? const Home() : const Login();
          //return const Home();
        },
      ),
    );
  }
}
