import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:strong_password/models/card.dart';
import 'package:strong_password/models/password.dart';

class PasswordNotifier extends ChangeNotifier {
  late Box<Password> boxPasswords;
  late Box<CreditCard> cardBox;


  Future<void> initializeBoxes() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PasswordAdapter());
    Hive.registerAdapter(CreditCardAdapter());

    boxPasswords = await Hive.openBox<Password>('passwordsBox');
    cardBox = await Hive.openBox<CreditCard>('cardBox');
  }
}
