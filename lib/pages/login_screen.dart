import 'package:flutter/material.dart';
import 'package:mchat/models/chat_api_service.dart';
import 'package:mchat/pages/bottomnav.dart';
import '../models/auth_handler.dart';
import '../models/signalr_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double boldFontSize = 25.0;
  double normalFontSize = 18.0;
  Color? greyColor = Colors.grey[700];
  Color? blueColor = Colors.blue[700];

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMe = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    SignalRService.initialize();
  }

  Future<void> authenticate() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both username and password')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {

      var response = await ChatApiService.login(
        _usernameController.text.trim(),
        _passwordController.text.trim()
      );
      await AuthHandler.saveLoginData(response as Map<String, dynamic>);
      print('Login Response: $response');

      if (response.isNotEmpty) {
        Navigator.pushReplacementNamed(context, '/chat');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid username or password')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        "Sign in",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: boldFontSize,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Sign in to continue to Mchat",
                        style: TextStyle(
                          fontSize: normalFontSize,
                          fontWeight: FontWeight.w400,
                          color: greyColor,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: screenWidth > 500 ? 450 : double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Username",
                                  style: TextStyle(fontSize: normalFontSize, color: greyColor)),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _usernameController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: normalFontSize),
                                decoration: _buildInputDecoration("Enter your username"),
                              ),
                              const SizedBox(height: 20),
                              Text("Password",
                                  style: TextStyle(fontSize: normalFontSize, color: greyColor)),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                style: TextStyle(fontSize: normalFontSize),
                                decoration: _buildInputDecoration("Enter your password"),
                                onSubmitted: (_) => authenticate(),
                              ),
                              const SizedBox(height: 20),
                              const SizedBox(height: 15),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all<Color>(blueColor!),
                                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    ),
                                    padding: WidgetStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.symmetric(vertical: 15)),
                                  ),
                                  onPressed: _isLoading ? null : authenticate,
                                  child: Text("Sign in",
                                      style: TextStyle(color: Colors.white, fontSize: boldFontSize)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 15.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.grey[200],
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}