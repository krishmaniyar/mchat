import 'package:flutter/material.dart';
import 'package:mchat/pages/chatting_page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {

  double boldFontSize = 30.0;
  double normalFontSize = 20.0;
  Color? greyColor = Colors.grey[700];
  Color? blueColor = Colors.blue[700];

  bool isDirect = true;

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
                "Chats",
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
                  hintText: "Search user",
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
                            backgroundColor: WidgetStateProperty.all<Color>((isDirect ? Colors.white : Colors.grey[300])!),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          onPressed: () => {
                            setState(() {
                              isDirect = !isDirect;
                            }),
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: Text(
                              "Direct",
                              style: TextStyle(
                                fontSize: normalFontSize,
                                fontWeight: FontWeight.w400,
                                color: (isDirect ? Colors.grey[700] : Colors.grey[500]),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>((!isDirect ? Colors.white : Colors.grey[300])!),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          onPressed: () => {
                            setState(() {
                              isDirect = !isDirect;
                            }),
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: Text(
                              "Groups",
                              style: TextStyle(
                                fontSize: normalFontSize,
                                fontWeight: FontWeight.w400,
                                color: (!isDirect ? Colors.grey[700] : Colors.grey[500]),
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
              GestureDetector(
                onTap: () => {
                  setState(() {
                    Navigator.pop(
                    context,
                    );
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChattingPage()),
                    );
                  })
                },
                child: Container(
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
                              "hi",
                              style: TextStyle(
                                fontSize: normalFontSize-3,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "5/15/2025 11:05:11 AM",
                        style: TextStyle(
                          fontSize: normalFontSize-8,
                          color: greyColor,
                        ),
                      ),
                    ],
                  ),
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
                            "",
                            style: TextStyle(
                              fontSize: normalFontSize-3,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 10,),
                    // Text(
                    //   "5/15/2025 11:05:11 AM",
                    //   style: TextStyle(
                    //     fontSize: normalFontSize-8,
                    //     color: greyColor,
                    //   ),
                    // ),
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
                            "",
                            style: TextStyle(
                              fontSize: normalFontSize-3,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 10,),
                    // Text(
                    //   "5/15/2025 11:05:11 AM",
                    //   style: TextStyle(
                    //     fontSize: normalFontSize-8,
                    //     color: greyColor,
                    //   ),
                    // ),
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
