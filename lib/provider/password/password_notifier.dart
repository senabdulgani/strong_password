import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:strong_password/models/card.dart';
import 'package:strong_password/models/password.dart';
import 'package:strong_password/provider/password/password_service.dart';

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

  List<Password> passwords = [];
  PasswordService passwordService = PasswordService();

  Future<void> getAllPasswords() async {
    await passwordService.getAllPasswords().then((value) {
      passwords = value;

      notifyListeners();
    });
  }

  // Future<void> deletePhotoList() async {
  //   await passwordService.deleteAllPhotos();
  //   List<Password> allphotos = await passwordService.getAllPhotos();
  //   for (var photo in allphotos) {
  //     await File(photo.name).delete();
  //   }
  //   passwords = [];

  //   notifyListeners();
  // }

  Future<void> deletePassword(Password password) async {
    // await password.delete();
    // File(password.path).delete();

    passwords.remove(password);
    password.save();

    notifyListeners();
  }

  Future<void> addPassword({
    required Password photo,
  }) async {
    
    passwords.add(photo);
    
    notifyListeners();
  }

  Future<void> updatePassword({
    required Password photo,
  }) async {
    passwords[passwords.indexOf(photo)] = photo;
    notifyListeners();
  }

  void passwordChangeFavoriteState(BuildContext context, Password password) {
    passwords[passwords.indexOf(password)].isFavorite =
        !passwords[passwords.indexOf(password)].isFavorite;
    password.save();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: passwords[passwords.indexOf(password)].isFavorite
            ? const Text('Removed from favourites')
            : const Text('Added to favourites'),
        duration: const Duration(milliseconds: 300),
      ),
    );

    notifyListeners();
  }


}
