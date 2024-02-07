import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:strong_password/View/pages/home_page.dart';
import 'package:strong_password/models/Hive/boxes.dart';
import 'package:strong_password/models/Hive/password.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PasswordAdapter());
  boxPasswords = await Hive.openBox<Password>('passwordsBox');
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(
                20,
              ),
            ),
          ),
        ),
        useMaterial3: true,
        brightness: isDark ? Brightness.dark : Brightness.light);

    return MaterialApp(
      title: 'Strong Password',
      theme: themeData,
      home: const StrongPassword(),
    );
  }
}
