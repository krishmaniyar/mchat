import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  double boldFontSize = 30.0;
  double normalFontSize = 20.0;
  Color? greyColor = Colors.grey[700];
  Color? blueColor = Colors.blue[700];

  final TextEditingController searchController = TextEditingController();

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
                "Settings",
                style: TextStyle(
                  fontSize: boldFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.0,),
              Divider(),
              SizedBox(height: 15.0,),
              TextField(
                controller: searchController,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontSize: normalFontSize,
                ),
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  hintText: "Search settings",
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
                  border: Border.all(color: Colors.grey.shade500, width: 1),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.green[200],
                          child: Text(
                            "M",
                            style: TextStyle(
                              color: Colors.green[800],
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
                            "test@gmail.com",
                            style: TextStyle(
                              fontSize: normalFontSize-3,
                            ),
                          )
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => {}, 
                      icon: Icon(Icons.logout_outlined),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Chat Activity",
                    style: TextStyle(
                      color: greyColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () => {},
                    child: Text(
                      "Delete from all devices",
                      style: TextStyle(
                        color: greyColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.red!),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: () => {},
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete_outlined,
                                color: Colors.white,
                                size: normalFontSize+3,
                              ),
                              SizedBox(width: 5,),
                              Text(
                                "Delete All Chat",
                                style: TextStyle(
                                  fontSize: normalFontSize,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          )
                        ),
                      )
                    ),
                    SizedBox(height: 15,),
                    Divider(),
                    SizedBox(height: 15,),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.red!),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: () => {},
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete_outlined,
                                color: Colors.white,
                                size: normalFontSize+3,
                              ),
                              SizedBox(width: 5,),
                              Text(
                                "Delete All Chat With Star",
                                style: TextStyle(
                                  fontSize: normalFontSize,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          )
                        ),
                      )
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
}