import 'package:erp_solution/provider/auth_provider.dart';
import 'package:erp_solution/screens/social_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/remember_me_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool isApiCallProcess = false;
  bool _rememberMe = false;

  // Add RememberMeService instance
  final RememberMeService _rememberMeService = RememberMeService();

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
  }

  // Load remembered credentials from storage
  void _loadRememberedCredentials() async {
    final credentials = await _rememberMeService.loadCredentials();

    setState(() {
      _rememberMe = credentials['rememberMe'];
      if (_rememberMe) {
        _emailController.text = credentials['username'];
        _passwordController.text = credentials['password'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // No need to navigate here - authProvider will trigger rebuild
        // and main.dart will handle navigation
        return Scaffold(
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Colors.red[900]!,
                      Colors.red[800]!,
                      Colors.orange[300]!,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 80),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Image.asset(
                              'assets/nagad_people_culture.png',
                              height: 150,
                              width: 350,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 40),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Welcome to Nagad People & Culture",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    SizedBox(height: 60),
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      margin: EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromRGBO(
                                              225,
                                              95,
                                              27,
                                              .3,
                                            ),
                                            blurRadius: 20,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.grey.shade200,
                                                ),
                                              ),
                                            ),
                                            child: TextFormField(
                                              controller: _emailController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration: InputDecoration(
                                                labelText: "User Name",
                                                prefixIcon: Icon(Icons.person),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.grey.shade200,
                                                ),
                                              ),
                                            ),
                                            child: TextFormField(
                                              controller: _passwordController,
                                              obscureText: _obscurePassword,
                                              decoration: InputDecoration(
                                                labelText: "Password",
                                                prefixIcon: Icon(Icons.lock),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _obscurePassword =
                                                          !_obscurePassword;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    _obscurePassword
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          // Remember Me Checkbox Row
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: _rememberMe,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _rememberMe =
                                                        value ?? false;
                                                  });
                                                },
                                                activeColor: Colors.red[900],
                                              ),
                                              Text(
                                                "Remember Me",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Forgot Password?",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Container(
                                      height: 50,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 50,
                                      ),
                                      child: ElevatedButton(
                                        onPressed: authProvider.isLoading
                                            ? null
                                            : () async {
                                                await loginUser();
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red[900],
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Login",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 60),
                                    SocialLogin(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (authProvider.isLoading)
                AbsorbPointer(
                  absorbing: true,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(color: Colors.redAccent),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> loginUser() async {
    String username = _emailController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both username and password")),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      await authProvider.login(username, password);

      // Save credentials based on Remember Me checkbox
      await _rememberMeService.saveCredentials(
        username: username,
        password: password,
        rememberMe: _rememberMe,
      );

      // Navigation is handled by main.dart based on authProvider.isLoggedIn
      // No need to navigate here
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login failed: $e")));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
