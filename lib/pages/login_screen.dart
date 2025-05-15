import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mchat/pages/bottomnav.dart';
import 'package:mchat/pages/chats_page.dart';

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

  late var rememberMe = false;

  void authenticate() {
    try{
      print(usernameController.text);
      if(usernameController.text.trim() == "shreeji") {
        if(passwordController.text == "123456") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNav()),
          );
        }
      }
    }
    catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        height: MediaQuery.of(context).size.height,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 60, horizontal: 30),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Form(
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 30,),
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
                      )
                    ],
                  ),
                  SizedBox(height: 30.0,),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      // height: MediaQuery.of(context).size.height/2.2,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Username",
                            style: TextStyle(
                              fontSize: normalFontSize,
                              color: greyColor,
                            ),
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: usernameController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              fontSize: normalFontSize,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter your login or email",
                              contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              filled: true,
                              fillColor: Colors.grey[300],
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Password",
                            style: TextStyle(
                              fontSize: normalFontSize,
                              color: greyColor,
                            ),
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            style: TextStyle(
                              fontSize: normalFontSize,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter your password",
                              contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              filled: true,
                              fillColor: Colors.grey[300],
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value!;
                                  });
                                }
                              ),
                              Text(
                                "Remember me",
                                style: TextStyle(
                                  fontSize: normalFontSize-2,
                                  color: greyColor,
                                ),
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () => {},
                                child: Text(
                                  "Reset Password",
                                  style: TextStyle(
                                    color: blueColor,
                                    fontSize: normalFontSize-2,
                                  ),
                                )
                              )
                            ],
                          ),
                          SizedBox(height: 15),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(blueColor!),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                ),
                              )
                            ),
                            onPressed: () => {
                              setState(() {
                                authenticate();
                              }),
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Center(
                                child: Text(
                                  "Sign in",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: boldFontSize,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  fontSize: normalFontSize-2,
                                  color: greyColor,
                                ),
                              ),
                              TextButton(
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: normalFontSize-2,
                                    color: blueColor,
                                  ),
                                ),
                                onPressed: () => {},
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
