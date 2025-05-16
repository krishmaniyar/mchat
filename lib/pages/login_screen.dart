import 'package:flutter/material.dart';
import 'package:mchat/pages/bottomnav.dart';

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

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

  void authenticate() {
    try {
      print(usernameController.text);
      if (usernameController.text.trim() == "shreeji" &&
          passwordController.text == "123456") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNav()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
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
                      Text(
                        "Sign in",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: boldFontSize,
                        ),
                      ),
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
                              Text("Username", style: TextStyle(fontSize: normalFontSize, color: greyColor)),
                              const SizedBox(height: 10),
                              TextField(
                                controller: usernameController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: normalFontSize),
                                decoration: _buildInputDecoration("Enter your login or email"),
                              ),
                              const SizedBox(height: 20),
                              Text("Password", style: TextStyle(fontSize: normalFontSize, color: greyColor)),
                              const SizedBox(height: 10),
                              TextField(
                                controller: passwordController,
                                obscureText: true,
                                style: TextStyle(fontSize: normalFontSize),
                                decoration: _buildInputDecoration("Enter your password"),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Checkbox(
                                    value: rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        rememberMe = value!;
                                      });
                                    },
                                  ),
                                  Text("Remember me", style: TextStyle(fontSize: normalFontSize - 2, color: greyColor)),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text("Reset Password", style: TextStyle(color: blueColor, fontSize: normalFontSize - 2)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all<Color>(blueColor!),
                                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    ),
                                  ),
                                  onPressed: authenticate,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    child: Text("Sign in", style: TextStyle(color: Colors.white, fontSize: boldFontSize)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Don't have an account?", style: TextStyle(fontSize: normalFontSize - 2, color: greyColor)),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text("Sign Up", style: TextStyle(fontSize: normalFontSize - 2, color: blueColor)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(20),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(20),
      ),
      filled: true,
      fillColor: Colors.grey[300],
    );
  }
}
