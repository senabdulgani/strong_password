import 'package:hive/hive.dart';

part 'card.g.dart';

@HiveType(typeId: 2)
class CreditCard {
  @HiveField(0)
  String cardHolder;

  @HiveField(1)
  String cardNumber;

  @HiveField(2)
  String cardExpiry;

  @HiveField(3)
  late String? cardCvv;

  @HiveField(4)
  String? cardIssuer;

  @HiveField(5)
  String? cardName;

  @HiveField(6)
  bool isFavorite;

  CreditCard({
    required this.cardHolder,
    required this.cardNumber,
    required this.cardExpiry,
    this.isFavorite = false,
    this.cardCvv,
    this.cardIssuer,
    this.cardName,
    });
}