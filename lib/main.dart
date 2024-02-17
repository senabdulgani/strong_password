import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strong_password/View/pages/Introduction/check_password_page.dart';
import 'package:strong_password/View/pages/Introduction/detect_password_view.dart';
import 'package:strong_password/models/card.dart';
import 'package:strong_password/models/password.dart';
import 'package:strong_password/provider/credit_card/credit_card_notifier.dart';
import 'package:strong_password/provider/password/password_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // todo Bu belki işe yaramazdır kontrol et.

  await Hive.initFlutter();
  
  // Register Hive Adapters for your models
  Hive.registerAdapter(PasswordAdapter());
  Hive.registerAdapter(CreditCardAdapter());

  // Open Hive boxes
  // await Hive.openBox<Password>('passwordsBox');
  // await Hive.openBox<CreditCard>('cardBox');

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLogin = prefs.getBool('firstLogin') ?? true;
  String? appPassword = prefs.getString('appPassword');

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
        ChangeNotifierProvider(create: (context) => CreditCardNotifier()),
      ],
      child: MaterialApp(
        title: 'Strong Password',
        theme: themeData,
        home: appPassword == null ? DetectPassword() : const CheckPassword(),
      ),
    );
  }
}
