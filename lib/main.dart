import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strong_password/View/pages/Introduction/check_password_page.dart';
import 'package:strong_password/View/pages/Introduction/detect_password_view.dart';
import 'package:strong_password/provider/password/password_notifier.dart';

void main() async {

  PasswordNotifier().initializeBoxes();

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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PasswordNotifier(),
        ),
      ],
      child: MaterialApp(
        title: 'Strong Password',
        theme: themeData,
        home: appPassword == null ? DetectPassword() : const CheckPassword(),
      ),
    );
  }
}
