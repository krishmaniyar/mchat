import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController searchController = TextEditingController();

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
                "Settings",
                style: TextStyle(
                  fontSize: boldFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: verticalPaddingSmall),
              const Divider(),
              // SizedBox(height: verticalPaddingMedium),
              // TextField(
              //   controller: searchController,
              //   keyboardType: TextInputType.text,
              //   style: TextStyle(
              //     fontSize: normalFontSize,
              //   ),
              //   decoration: InputDecoration(
              //     suffixIcon: Icon(Icons.search),
              //     hintText: "Search settings",
              //     contentPadding: EdgeInsets.symmetric(
              //       vertical: screenHeight * 0.02,
              //       horizontal: screenWidth * 0.0375,
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: const BorderSide(color: Colors.white),
              //       borderRadius: BorderRadius.circular(containerBorderRadius),
              //     ),
              //     enabledBorder: UnderlineInputBorder(
              //       borderSide: const BorderSide(color: Colors.white),
              //       borderRadius: BorderRadius.circular(containerBorderRadius),
              //     ),
              //     filled: true,
              //     fillColor: Colors.grey[300],
              //   ),
              // ),
              SizedBox(height: verticalPaddingLarge),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: containerPaddingVertical,
                  horizontal: containerPaddingHorizontal,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(containerBorderRadius),
                  border: Border.all(
                    color: Colors.grey.shade500,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: avatarRadius,
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
                            padding: EdgeInsets.all(statusIndicatorSize * 0.5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: Colors.white
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
                            "test@gmail.com",
                            style: TextStyle(
                              fontSize: smallFontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.logout_outlined),
                    ),
                  ],
                ),
              ),
              SizedBox(height: verticalPaddingSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Chat Activity",
                    style: TextStyle(
                      color: greyColor,
                      fontSize: normalFontSize,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Delete from all devices",
                      style: TextStyle(
                        color: greyColor,
                        fontSize: smallFontSize,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: verticalPaddingSmall),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: verticalPaddingLarge,
                  horizontal: containerPaddingHorizontal,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(containerBorderRadius),
                ),
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(buttonBorderRadius),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: verticalPaddingMedium,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_outlined,
                              color: Colors.white,
                              size: normalFontSize - 3,
                            ),
                            SizedBox(width: screenWidth * 0.0125),
                            Text(
                              "Delete All Chat",
                              style: TextStyle(
                                fontSize: normalFontSize-3,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: verticalPaddingMedium),
                    const Divider(),
                    SizedBox(height: verticalPaddingMedium),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(buttonBorderRadius),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: verticalPaddingMedium,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_outlined,
                              color: Colors.white,
                              size: normalFontSize-3,
                            ),
                            SizedBox(width: screenWidth * 0.0125),
                            Text(
                              "Delete All Chat With Star",
                              style: TextStyle(
                                fontSize: normalFontSize-3,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: verticalPaddingLarge),
            ],
          ),
        ),
      ),
    );
  }
}