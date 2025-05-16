import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
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
                "Friends",
                style: TextStyle(
                  fontSize: boldFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: verticalPaddingSmall),
              const Divider(),
              SizedBox(height: verticalPaddingMedium),
              TextField(
                controller: searchController,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontSize: normalFontSize,
                ),
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  hintText: "Search user",
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.0375,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                ),
              ),
              SizedBox(height: verticalPaddingLarge),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: containerPaddingVertical,
                  horizontal: containerPaddingHorizontal,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(containerBorderRadius),
                  border: Border.all(color: Colors.blue.shade500, width: 2),
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
                    PopupMenuButton<int>(
                      icon: Icon(Icons.more_horiz),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Row(
                            children: [
                              Text("Start Chat", style: TextStyle(color: greyColor)),
                              SizedBox(width: screenWidth * 0.05),
                              Icon(Icons.chat_outlined, color: greyColor),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Row(
                            children: [
                              Text("Edit Contact", style: TextStyle(color: greyColor)),
                              SizedBox(width: screenWidth * 0.05),
                              Icon(Icons.edit_outlined, color: greyColor),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          value: 3,
                          child: Row(
                            children: [
                              Text("Delete user", style: TextStyle(color: greyColor)),
                              SizedBox(width: screenWidth * 0.05),
                              Icon(Icons.block_flipped, color: greyColor),
                            ],
                          ),
                        ),
                      ],
                      offset: Offset(0, screenHeight * 0.05),
                      color: Colors.white,
                      elevation: 2,
                      onSelected: (value) {
                        if (value == 1) {}
                        else if (value == 2) {}
                        else if (value == 3) {}
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
                    PopupMenuButton<int>(
                      icon: Icon(Icons.more_horiz),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Row(
                            children: [
                              Text("Start Chat", style: TextStyle(color: greyColor)),
                              SizedBox(width: screenWidth * 0.05),
                              Icon(Icons.chat_outlined, color: greyColor),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Row(
                            children: [
                              Text("Edit Contact", style: TextStyle(color: greyColor)),
                              SizedBox(width: screenWidth * 0.05),
                              Icon(Icons.edit_outlined, color: greyColor),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          value: 3,
                          child: Row(
                            children: [
                              Text("Delete user", style: TextStyle(color: greyColor)),
                              SizedBox(width: screenWidth * 0.05),
                              Icon(Icons.block_flipped, color: greyColor),
                            ],
                          ),
                        ),
                      ],
                      offset: Offset(0, screenHeight * 0.05),
                      color: Colors.white,
                      elevation: 2,
                      onSelected: (value) {
                        if (value == 1) {}
                        else if (value == 2) {}
                        else if (value == 3) {}
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
                    PopupMenuButton<int>(
                      icon: Icon(Icons.more_horiz),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Row(
                            children: [
                              Text("Start Chat", style: TextStyle(color: greyColor)),
                              SizedBox(width: screenWidth * 0.05),
                              Icon(Icons.chat_outlined, color: greyColor),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Row(
                            children: [
                              Text("Edit Contact", style: TextStyle(color: greyColor)),
                              SizedBox(width: screenWidth * 0.05),
                              Icon(Icons.edit_outlined, color: greyColor),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          value: 3,
                          child: Row(
                            children: [
                              Text("Delete user", style: TextStyle(color: greyColor)),
                              SizedBox(width: screenWidth * 0.05),
                              Icon(Icons.block_flipped, color: greyColor),
                            ],
                          ),
                        ),
                      ],
                      offset: Offset(0, screenHeight * 0.05),
                      color: Colors.white,
                      elevation: 2,
                      onSelected: (value) {
                        if (value == 1) {}
                        else if (value == 2) {}
                        else if (value == 3) {}
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: verticalPaddingLarge),
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
                      "Add Friends",
                      style: TextStyle(
                        fontSize: boldFontSize - 3,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}