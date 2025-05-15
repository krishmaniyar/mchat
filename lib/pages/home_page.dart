import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  double boldFontSize = 30.0;
  double normalFontSize = 20.0;
  Color? greyColor = Colors.grey[700];
  Color? blueColor = Colors.blue[700];

  late var rememberMe = false;

  final TextEditingController searchController = TextEditingController();
  final TextEditingController groupController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create Chat",
                style: TextStyle(
                  fontSize: boldFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.0,),
              Divider(),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    child: Row(
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          onPressed: () => {
                            setState(() {
                            }),
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                            child: Text(
                              "Group",
                              style: TextStyle(
                                fontSize: normalFontSize,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: groupController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontSize: normalFontSize,
                  ),
                  decoration: InputDecoration(
                    hintText: "Group Name",
                    contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 15.0),
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
              ),
              SizedBox(height: 20.0,),
              Text(
                "Select Member"
              ),
              SizedBox(height: 10.0,),
              TextField(
                controller: searchController,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontSize: normalFontSize,
                ),
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  hintText: "Select Member",
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 15.0),
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
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue.shade500, width: 2),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blue[200],
                          child: Text(
                            "M",
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: normalFontSize,
                            ),
                          ),
                        ),
                        Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                                padding: EdgeInsets.all(7.5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2,
                                      color: Colors.white
                                  ),
                                  borderRadius: BorderRadius.circular(90.0),
                                  color: Colors.green,
                                )
                            )
                        )
                      ],
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mehul",
                            style: TextStyle(
                              fontSize: normalFontSize,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "online",
                            style: TextStyle(
                              fontSize: normalFontSize-3,
                            ),
                          )
                        ],
                      ),
                    ),
                    Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      }
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  // border: Border.all(color: Colors.blue.shade500, width: 2),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blue[200],
                          child: Text(
                            "S",
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: normalFontSize,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.all(7.5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Colors.white
                              ),
                              borderRadius: BorderRadius.circular(90.0),
                              color: Colors.red,
                            )
                          )
                        )
                      ],
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SHM",
                            style: TextStyle(
                              fontSize: normalFontSize,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "offline",
                            style: TextStyle(
                              fontSize: normalFontSize-3,
                            ),
                          )
                        ],
                      ),
                    ),
                    Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      }
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  // border: Border.all(color: Colors.blue.shade500, width: 2),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blue[200],
                          child: Text(
                            "A",
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: normalFontSize,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.all(7.5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: Colors.white
                              ),
                              borderRadius: BorderRadius.circular(90.0),
                              color: Colors.red,
                            )
                          )
                        )
                      ],
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ASM",
                            style: TextStyle(
                              fontSize: normalFontSize,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "offline",
                            style: TextStyle(
                              fontSize: normalFontSize-3,
                            ),
                          )
                        ],
                      ),
                    ),
                    Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      }
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(blueColor!),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                onPressed: () => {},
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Text(
                      "Create Group",
                      style: TextStyle(
                        fontSize: boldFontSize-3,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
