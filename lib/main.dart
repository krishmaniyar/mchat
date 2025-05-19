import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mchat/pages/bottomnav.dart';
import 'package:mchat/pages/login_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'models/auth_handler.dart';

Future<String> getUniqueDeviceId() async {
  String uniqueDeviceId = '';

  var deviceInfo = DeviceInfoPlugin();

  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    uniqueDeviceId = '${iosDeviceInfo.name}:${iosDeviceInfo.identifierForVendor}';
  } else if(Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    uniqueDeviceId = '${androidDeviceInfo.name}:${androidDeviceInfo.id}' ;
  }
  return uniqueDeviceId;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthHandler.initialize();
  await FlutterDownloader.initialize();
  await Permission.storage.request();
  String deviceId = await getUniqueDeviceId();
  print('Device ID: $deviceId');

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => AuthWrapper(),
      '/login': (context) => LoginScreen(),
      '/chat': (context) => BottomNav(),
    },
  ));
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthHandler.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return snapshot.data == true ? BottomNav() : LoginScreen();
      },
    );
  }
}