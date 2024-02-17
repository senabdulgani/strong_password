import 'package:hive_flutter/hive_flutter.dart';
import 'package:strong_password/models/card.dart';

class CreditCardService {
  static const String _cardBoxName = 'creditCardBox';

  Future<Box<CreditCard>> get _box async {
    return await Hive.openBox<CreditCard>(_cardBoxName);
  }

  Future<void> addCard(CreditCard card) async {
    final box = await _box;
    await box.add(card);
  }

  Future<void> updateCard(CreditCard card, oldCardIndex) async {
    final box = await _box;
    await box.put(oldCardIndex, card);
  }

  Future<void> deleteCard(CreditCard card) async {
    final box = await _box;
    await box.deleteAt(box.values.toList().indexOf(card));
  }

  Future<List<CreditCard>> getAllCards() async {
    final box = await _box;
    return box.values.toList();
  }
}
