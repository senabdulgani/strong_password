import 'package:flutter/material.dart';
import 'package:strong_password/models/password.dart';
import 'package:strong_password/provider/password/password_service.dart';

class PasswordNotifier extends ChangeNotifier {

  List<Password> passwords = [];
  PasswordService passwordService = PasswordService();

  Future<void> getAllPasswords() async {
    await passwordService.getAllPasswords().then((value) {
      passwords = value;
      
      notifyListeners();
    });
  }

  Future<void> deletePassword(Password password) async {

    passwords.remove(password);
    await passwordService.deletePassword(password);

    notifyListeners();
  }

  Future<void> addPassword({
    required Password password,
  }) async {
    
    passwords.add(password);
    await passwordService.addPassword(password);
    
    notifyListeners();
  }

  Future<void> updatePassword({
    required Password password,
    required oldPasswordIndex,
  }) async {
    passwords[oldPasswordIndex] = password;
    await passwordService.updatePassword(password, oldPasswordIndex);
    notifyListeners();
  }

  void passwordChangeFavoriteState(BuildContext context, Password password) {
    passwords[passwords.indexOf(password)].isFavorite =
        !passwords[passwords.indexOf(password)].isFavorite;

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
