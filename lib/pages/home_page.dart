import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late var rememberMe = false;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController groupController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final boldFontSize = screenHeight * 0.035;
    final normalFontSize = screenHeight * 0.025;
    final smallFontSize = screenHeight * 0.02;

    final greyColor = Colors.grey[700];
    final blueColor = Colors.blue[700];

    final horizontalPadding = screenWidth * 0.05;
    final verticalPaddingSmall = screenHeight * 0.0125;
    final verticalPaddingMedium = screenHeight * 0.01875;
    final verticalPaddingLarge = screenHeight * 0.025;

    final avatarRadius = screenWidth * 0.06;
    final containerPaddingVertical = screenHeight * 0.01875;
    final containerPaddingHorizontal = screenWidth * 0.05;
    final containerBorderRadius = screenWidth * 0.035;
    final statusIndicatorSize = screenWidth * 0.035;
    final buttonBorderRadius = screenWidth * 0.025;
    final toggleButtonRadius = screenWidth * 0.0875;
    final toggleButtonInnerRadius = screenWidth * 0.075;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 0.0,
            horizontal: horizontalPadding,
          ),
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
              SizedBox(height: verticalPaddingSmall),
              const Divider(),
              // SizedBox(height: verticalPaddingMedium),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       padding: EdgeInsets.all(screenWidth * 0.0125),
              //       decoration: BoxDecoration(
              //         color: Colors.grey[300],
              //         borderRadius: BorderRadius.circular(toggleButtonRadius),
              //       ),
              //       child: Row(
              //         children: [
              //           TextButton(
              //             style: ButtonStyle(
              //               backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
              //               shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              //                 RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(toggleButtonInnerRadius),
              //                 ),
              //               ),
              //             ),
              //             onPressed: () {},
              //             child: Padding(
              //               padding: EdgeInsets.symmetric(
              //                 vertical: screenHeight * 0.00625,
              //                 horizontal: screenWidth * 0.05,
              //               ),
              //               child: Text(
              //                 "Group",
              //                 style: TextStyle(
              //                   fontSize: normalFontSize,
              //                   fontWeight: FontWeight.w400,
              //                   color: greyColor,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: verticalPaddingLarge),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.025,
                  horizontal: screenWidth * 0.0375,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(containerBorderRadius),
                ),
                child: TextField(
                  controller: groupController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontSize: normalFontSize,
                  ),
                  decoration: InputDecoration(
                    hintText: "Group Name",
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: screenWidth * 0.0375,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(containerBorderRadius),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(containerBorderRadius),
                    ),
                    filled: true,
                    fillColor: Colors.grey[300],
                  ),
                ),
              ),
              SizedBox(height: verticalPaddingLarge),
              Text(
                "Select Member",
                style: TextStyle(fontSize: normalFontSize),
              ),
              SizedBox(height: verticalPaddingSmall),
              TextField(
                controller: searchController,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontSize: normalFontSize,
                ),
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  hintText: "Select Member",
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.0375,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(containerBorderRadius),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(containerBorderRadius),
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                ),
              ),
              SizedBox(height: verticalPaddingMedium),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: containerPaddingVertical,
                          horizontal: containerPaddingHorizontal,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(containerBorderRadius),
                          border: Border.all(
                            color: Colors.blue.shade500,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: avatarRadius,
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
                                    padding: EdgeInsets.all(statusIndicatorSize * 0.5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.circular(statusIndicatorSize),
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: screenWidth * 0.025),
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
                                      fontSize: smallFontSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: verticalPaddingMedium),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: containerPaddingVertical,
                          horizontal: containerPaddingHorizontal,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(containerBorderRadius),
                        ),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: avatarRadius,
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
                                    padding: EdgeInsets.all(statusIndicatorSize * 0.5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.circular(statusIndicatorSize),
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: screenWidth * 0.025),
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
                                      fontSize: smallFontSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: verticalPaddingMedium),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: containerPaddingVertical,
                          horizontal: containerPaddingHorizontal,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(containerBorderRadius),
                        ),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: avatarRadius,
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
                                    padding: EdgeInsets.all(statusIndicatorSize * 0.5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.circular(statusIndicatorSize),
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: screenWidth * 0.025),
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
                                      fontSize: smallFontSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: verticalPaddingMedium),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(blueColor!),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(buttonBorderRadius),
                    ),
                  ),
                ),
                onPressed: () {},
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.0125,
                      horizontal: screenWidth * 0.0375,
                    ),
                    child: Text(
                      "Create Group",
                      style: TextStyle(
                        fontSize: boldFontSize - 3,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: verticalPaddingMedium),
            ],
          ),
        ),
      ),
    );
  }
}