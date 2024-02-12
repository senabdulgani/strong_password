import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strong_password/View/pages/check_password_page.dart';
import 'package:strong_password/View/pages/detect_password_view.dart';
import 'package:strong_password/models/boxes.dart';
import 'package:strong_password/models/card.dart';
import 'package:strong_password/models/password.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PasswordAdapter());
  boxPasswords = await Hive.openBox<Password>('passwordsBox');
  Hive.registerAdapter(CreditCardAdapter());
  cardBox = await Hive.openBox<CreditCard>('cardBox');

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLogin = prefs.getBool('firstLogin') ?? true;
  String? appPassword = prefs.getString('appPassword') ;

  runApp(MyApp(
    isFirstLogin: isFirstLogin,
    appPassword: appPassword,
  ));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({
    super.key,
    required this.isFirstLogin,
    required this.appPassword,
  });

  final bool isFirstLogin;
  final String? appPassword;
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.vertical(
          //     bottom: Radius.circular(
          //       20,
          //     ),
          //   ),
          // ),
        ),
        useMaterial3: true,
        brightness: isDark ? Brightness.dark : Brightness.light);

    return MaterialApp(
      title: 'Strong Password',
      theme: themeData,
      home: appPassword == null ? const DetectPassword() : const CheckPassword(),
    );
  }
}
