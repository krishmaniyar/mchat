import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {

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
                "Friends",
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
                    PopupMenuButton<int>(
                      icon: Icon(Icons.more_horiz),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Row(
                            children: [
                              Text("Start Chat", style: TextStyle(color: greyColor),),
                              SizedBox(width: 20,),
                              Icon(Icons.chat_outlined, color: greyColor),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          // row with two children
                          child: Row(
                            children: [
                              Text("Edit Contact", style: TextStyle(color: greyColor),),
                              SizedBox(width: 20,),
                              Icon(Icons.edit_outlined, color: greyColor),
                            ],
                          ),
                        ),
                        PopupMenuDivider(),
                        PopupMenuItem(
                          value: 3,
                          // row with two children
                          child: Row(
                            children: [
                              Text("Delete user", style: TextStyle(color: greyColor),),
                              SizedBox(width: 20,),
                              Icon(Icons.block_flipped, color: greyColor),
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
                        else if (value == 3) {
                        }
                      },
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
                    PopupMenuButton<int>(
                      icon: Icon(Icons.more_horiz),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Row(
                            children: [
                              Text("Start Chat", style: TextStyle(color: greyColor),),
                              SizedBox(width: 20,),
                              Icon(Icons.chat_outlined, color: greyColor),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          // row with two children
                          child: Row(
                            children: [
                              Text("Edit Contact", style: TextStyle(color: greyColor),),
                              SizedBox(width: 20,),
                              Icon(Icons.edit_outlined, color: greyColor),
                            ],
                          ),
                        ),
                        PopupMenuDivider(),
                        PopupMenuItem(
                          value: 3,
                          // row with two children
                          child: Row(
                            children: [
                              Text("Delete user", style: TextStyle(color: greyColor),),
                              SizedBox(width: 20,),
                              Icon(Icons.block_flipped, color: greyColor),
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
                        else if (value == 3) {
                        }
                      },
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
                    PopupMenuButton<int>(
                      icon: Icon(Icons.more_horiz),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Row(
                            children: [
                              Text("Start Chat", style: TextStyle(color: greyColor),),
                              SizedBox(width: 20,),
                              Icon(Icons.chat_outlined, color: greyColor),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          // row with two children
                          child: Row(
                            children: [
                              Text("Edit Contact", style: TextStyle(color: greyColor),),
                              SizedBox(width: 20,),
                              Icon(Icons.edit_outlined, color: greyColor),
                            ],
                          ),
                        ),
                        PopupMenuDivider(),
                        PopupMenuItem(
                          value: 3,
                          // row with two children
                          child: Row(
                            children: [
                              Text("Delete user", style: TextStyle(color: greyColor),),
                              SizedBox(width: 20,),
                              Icon(Icons.block_flipped, color: greyColor),
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
                        else if (value == 3) {
                        }
                      },
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
                      "Add Friends",
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
