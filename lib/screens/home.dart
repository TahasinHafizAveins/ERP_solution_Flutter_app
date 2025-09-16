import 'package:erp_solution/service/token_service.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _token = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Welcome to Home Screen"), Text("Token: $_token")],
        ),
      ),
    );
  }

  Future<void> _loadToken() async {
    String token = await TokenService().loadToken();
    setState(() {
      _token = token;
    });
  }
}
