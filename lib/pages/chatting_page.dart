import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bottomnav.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {

  double boldFontSize = 30.0;
  double normalFontSize = 20.0;
  Color? greyColor = Colors.grey[700];
  Color? blueColor = Colors.blue[700];

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => {
                      setState(() {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BottomNav()),
                        );
                      })
                    },
                    icon: Icon(
                      CupertinoIcons.back,
                      size: boldFontSize,
                    ),
                  ),
                  SizedBox(width: 5,),
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
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(15),
                                    // border: Border.all(color: Colors.blue.shade500, width: 2),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.grey[400],
                                        child: IconButton(
                                            onPressed: () => {},
                                            icon: Icon(
                                              Icons.download_outlined,
                                              size: 30,
                                              color: Colors.grey[300],
                                            )
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        child: Text(
                                          "Screenshot_20250306-205317_Phone.jpg",
                                          style: TextStyle(
                                            fontSize: normalFontSize-2,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              PopupMenuButton<int>(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.grey[500],
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Favorite", style: TextStyle(color: greyColor, fontSize: normalFontSize),),
                                        Icon(Icons.star_border_outlined, color: greyColor, size: normalFontSize),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    // row with two children
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Delete", style: TextStyle(color: greyColor, fontSize: normalFontSize),),
                                        Icon(Icons.delete_outline_outlined, color: greyColor, size: normalFontSize,),
                                      ],
                                    ),
                                  ),
                                ],
                                offset: Offset(0, 40),
                                color: Colors.white,
                                elevation: 2,
                                onSelected: (value) {
                                  if (value == 1) {
                                  }
                                  else if (value == 2) {
                                  }
                                },
                              ),
                              SizedBox(width: 20,),
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "Mehul 3/12/2025 12:08:14 PM",
                          style: TextStyle(
                            color: greyColor
                          ),
                        ),
                        SizedBox(height: 15,),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                  // border: Border.all(color: Colors.blue.shade500, width: 2),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Hi",
                                      style: TextStyle(
                                        fontSize: normalFontSize-2,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              PopupMenuButton<int>(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.grey[500],
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Favorite", style: TextStyle(color: greyColor, fontSize: normalFontSize),),
                                        Icon(Icons.star_border_outlined, color: greyColor, size: normalFontSize),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    // row with two children
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Delete", style: TextStyle(color: greyColor, fontSize: normalFontSize),),
                                        Icon(Icons.delete_outline_outlined, color: greyColor, size: normalFontSize,),
                                      ],
                                    ),
                                  ),
                                ],
                                offset: Offset(0, 40),
                                color: Colors.white,
                                elevation: 2,
                                onSelected: (value) {
                                  if (value == 1) {
                                  }
                                  else if (value == 2) {
                                  }
                                },
                              ),
                              SizedBox(width: 20,),
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "Mehul 3/12/2025 12:08:14 PM",
                          style: TextStyle(
                              color: greyColor
                          ),
                        ),
                        SizedBox(height: 15,),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(height: 15,),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              PopupMenuButton<int>(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.grey[500],
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Favorite", style: TextStyle(color: greyColor, fontSize: normalFontSize),),
                                        Icon(Icons.star_border_outlined, color: greyColor, size: normalFontSize),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    // row with two children
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Delete", style: TextStyle(color: greyColor, fontSize: normalFontSize),),
                                        Icon(Icons.delete_outline_outlined, color: greyColor, size: normalFontSize,),
                                      ],
                                    ),
                                  ),
                                ],
                                offset: Offset(0, 40),
                                color: Colors.white,
                                elevation: 2,
                                onSelected: (value) {
                                  if (value == 1) {
                                  }
                                  else if (value == 2) {
                                  }
                                },
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.blue[500],
                                  borderRadius: BorderRadius.circular(15),
                                  // border: Border.all(color: Colors.blue.shade500, width: 2),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Hi",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: normalFontSize-2,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "Shreeji 3/12/2025 12:08:14 PM",
                          style: TextStyle(
                              color: greyColor
                          ),
                        ),
                        SizedBox(height: 15,),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(height: 15,),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              PopupMenuButton<int>(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.grey[500],
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Favorite", style: TextStyle(color: greyColor, fontSize: normalFontSize),),
                                        Icon(Icons.star_border_outlined, color: greyColor, size: normalFontSize),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    // row with two children
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Delete", style: TextStyle(color: greyColor, fontSize: normalFontSize),),
                                        Icon(Icons.delete_outline_outlined, color: greyColor, size: normalFontSize,),
                                      ],
                                    ),
                                  ),
                                ],
                                offset: Offset(0, 40),
                                color: Colors.white,
                                elevation: 2,
                                onSelected: (value) {
                                  if (value == 1) {
                                  }
                                  else if (value == 2) {
                                  }
                                },
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.blue[500],
                                  borderRadius: BorderRadius.circular(15),
                                  // border: Border.all(color: Colors.blue.shade500, width: 2),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "hi",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: normalFontSize-2,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "Shreeji 3/12/2025 12:08:14 PM",
                          style: TextStyle(
                              color: greyColor
                          ),
                        ),
                        SizedBox(height: 15,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: TextField(
                controller: messageController,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontSize: normalFontSize,
                ),
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: () => {}, 
                    icon: Icon(Icons.attach_file_outlined),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => {}, 
                    icon: Icon(Icons.send_outlined)
                  ),
                  hintText: "Type message",
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
            )
          ],
        )
      ),
    );
  }
}
