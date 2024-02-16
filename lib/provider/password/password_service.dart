import 'package:hive_flutter/hive_flutter.dart';
import 'package:strong_password/models/card.dart';
import 'package:strong_password/models/password.dart';

class PasswordService {
  
  static const String _boxName = 'passwordsBox';

  Future<Box<Password>> get _box async {
    return await Hive.openBox<Password>(_boxName);
  }

  Future<void> addPassword(Password password) async {
    final box = await _box;
    await box.add(password);
  }

  Future<void> updatePassword(Password password) async {
    final box = await _box;
    await box.put(password.name, password);
  }

  Future<void> deleteAllPasswords() async {
    final box = await _box;
    await box.clear();
  }

  Future<List<Password>> getAllPasswords() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<Password?> hasPassword(String name) async {
    var box = Hive.box<Password>('photos');
    Password? foundPhoto;
    for (var photo in box.values) {
      if (photo.name.contains(name)) {
        foundPhoto = photo;
        break;
      }
    }

    if (foundPhoto != null) {
      return foundPhoto;
    } else {
      return null;
    }
  }
}

class CreditCardService {
  static const String _boxName = 'cardBox';

  Future<Box<CreditCard>> get _box async {
    return await Hive.openBox<CreditCard>(_boxName);
  }

  Future<void> addCard(CreditCard card) async {
    final box = await _box;
    await box.add(card);
  }

  Future<void> updateCard(CreditCard card) async {
    final box = await _box;
    await box.put(card.cardNumber, card);
  }

  Future<void> deleteAllCards() async {
    final box = await _box;
    await box.clear();
  }

  Future<List<CreditCard>> getAllCards() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<CreditCard?> hasCard(String name) async {
    var box = Hive.box<CreditCard>('cards');
    CreditCard? foundCard;
    for (var card in box.values) {
      if (card.cardNumber.contains(name)) {
        foundCard = card;
        break;
      }
    }

    if (foundCard != null) {
      return foundCard;
    } else {
      return null;
    }
  }
}
