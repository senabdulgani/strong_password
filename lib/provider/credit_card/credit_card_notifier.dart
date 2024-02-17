import 'package:flutter/material.dart';
import 'package:strong_password/models/card.dart';
import 'package:strong_password/provider/credit_card/credit_card_service.dart';

class CreditCardNotifier extends ChangeNotifier {

  List<CreditCard> cards = [];
  CreditCardService creditCardService = CreditCardService();

  Future<void> getAllCards() async {
    await creditCardService.getAllCards().then((value) {
      cards = value;
      
      notifyListeners();
    });
  }

  Future<void> deleteCard(CreditCard card) async {

    cards.remove(card);
    await creditCardService.deleteCard(card);

    notifyListeners();
  }

  Future<void> addCard({
    required CreditCard card,
  }) async {
    
    cards.add(card);
    await creditCardService.addCard(card);
    
    notifyListeners();
  }

  Future<void> updateCard({
    required CreditCard card,
    required oldCardIndex,
  }) async {
    cards[oldCardIndex] = card;
    await creditCardService.updateCard(card, oldCardIndex);
    notifyListeners();
  }

  // void cardChangeFavoriteState(BuildContext context, CreditCard card) {
  //   cards[cards.indexOf(card)].isFavorite =
  //       !cards[cards.indexOf(card)].isFavorite;

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: cards[cards.indexOf(card)].isFavorite
  //           ? const Text('Removed from favourites')
  //           : const Text('Added to favourites'),
  //       duration: const Duration(milliseconds: 300),
  //     ),
  //   );
  //   notifyListeners();
  // }
}
