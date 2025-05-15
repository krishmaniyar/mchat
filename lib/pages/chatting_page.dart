import 'package:flutter/material.dart';

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
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
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
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: Container()
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
