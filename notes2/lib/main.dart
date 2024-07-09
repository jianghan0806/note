import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:notes1/ui/login.dart';
import 'package:notes1/ui/guide_page.dart';
import 'package:notes1/utils/api_service.dart';
import 'package:notes1/ui/settings_page.dart'; // Import your settings page

void main() {
  runApp(MyApp());
  // 透明状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService(); // Create an instance of ApiService

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        title: '闪亮日记本',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        initialRoute: '/guide', // Define initial route
        routes: {
          '/guide': (context) => GuidePage(apiService: apiService), // Define guide route
          '/login': (context) => LoginPage(apiService: apiService), // Define login route
          '/settings': (context) => SettingsPage(
            fontSize: 16.0,
            onFontSizeChanged: (double? newSize) {},
          ), // Define settings route
        },
      ),
      backgroundColor: Colors.black54,
      textPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      radius: 20.0,
      position: ToastPosition.bottom,
    );
  }
}
