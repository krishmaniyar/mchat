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

  final List<String> options = [
    '1 Minute',
    '5 Minute',
    '1 Hour',
    '8 Hour',
    '12 Hour',
    '1 Day',
    '1 Week',
    '1 Month',
    '1 Year',
    'Off'
  ];

  String selectedOption = 'Off';

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BottomNav()),
                      );
                    },
                    icon: Icon(CupertinoIcons.back, size: boldFontSize),
                  ),
                  const SizedBox(width: 5),
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
                          padding: const EdgeInsets.all(7.5),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.circular(90.0),
                            color: Colors.green,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Mehul",
                            style: TextStyle(
                                fontSize: normalFontSize,
                                fontWeight: FontWeight.w700)),
                        Text("online",
                            style: TextStyle(fontSize: normalFontSize - 3)),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert),
                    initialValue: selectedOption,
                    onSelected: (String value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return options.map((String option) {
                        return PopupMenuItem<String>(
                          value: option,
                          child: Row(
                            children: [
                              Radio<String>(
                                value: option,
                                groupValue: selectedOption,
                                onChanged: (_) {},
                              ),
                              SizedBox(width: 8),
                              Text(option),
                            ],
                          ),
                        );
                      }).toList();
                    },
                  ),
                  SizedBox(width: 5,),
                ],
              ),
            ),
            const Divider(),

            // Messages area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildFileMessageBubble("Mehul", "Screenshot_20250306-205317_Phone.jpg"),
                    _buildTextMessageBubble("Mehul", "Hi", isSender: false),
                    _buildTextMessageBubble("Shreeji", "Hi", isSender: true),
                    _buildTextMessageBubble("Shreeji", "hi", isSender: true),
                  ],
                ),
              ),
            ),

            const Divider(),

            // Input field
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: TextField(
                controller: messageController,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: normalFontSize),
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.attach_file_outlined),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send_outlined),
                  ),
                  hintText: "Type message",
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 15.0),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileMessageBubble(String sender, String fileName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[400],
                        child: Icon(Icons.download_outlined,
                            size: 30, color: Colors.grey[300]),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          fileName,
                          style: TextStyle(
                            fontSize: normalFontSize - 2,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _popupMenu(),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text("$sender 3/12/2025 12:08:14 PM", style: TextStyle(color: greyColor)),
      ],
    );
  }

  Widget _buildTextMessageBubble(String sender, String message,
      {required bool isSender}) {
    return Column(
      crossAxisAlignment:
      isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isSender) ...[],
            if (isSender) _popupMenu(),
            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
              padding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: isSender ? Colors.blue[500] : Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: normalFontSize - 2,
                  fontWeight: FontWeight.w700,
                  color: isSender ? Colors.white : Colors.black,
                ),
              ),
            ),
            if (!isSender) _popupMenu(),
          ],
        ),
        const SizedBox(height: 5),
        Text("$sender 3/12/2025 12:08:14 PM", style: TextStyle(color: greyColor)),
      ],
    );
  }

  Widget _popupMenu() {
    return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert, color: Colors.grey[500]),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Favorite",
                  style: TextStyle(color: greyColor, fontSize: normalFontSize)),
              Icon(Icons.star_border_outlined,
                  color: greyColor, size: normalFontSize),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Delete",
                  style: TextStyle(color: greyColor, fontSize: normalFontSize)),
              Icon(Icons.delete_outline_outlined,
                  color: greyColor, size: normalFontSize),
            ],
          ),
        ),
      ],
      offset: const Offset(0, 40),
      color: Colors.white,
      elevation: 2,
      onSelected: (value) {},
    );
  }
}
