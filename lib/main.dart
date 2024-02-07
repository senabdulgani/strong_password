import 'package:flutter/material.dart';
import 'package:strong_password/home_page.dart';

void main() {
  runApp(
    MyApp());
    debugPrint('App is running');
}


// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),),
        useMaterial3: true,
        brightness: isDark ? Brightness.dark : Brightness.light);
    
    return MaterialApp(
      title: 'Strong Password',
      theme: themeData,
      home: const StrongPassword(),
    );
  }
}