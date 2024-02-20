import 'package:hive_flutter/hive_flutter.dart';
import 'package:strong_password/models/password.dart';

class PasswordService {
  static const String _passwordBoxName = 'passwordsBox';

  Future<Box<Password>> get _box async {
    return await Hive.openBox<Password>(_passwordBoxName);
  }

  Future<void> addPassword(Password password) async {
    final box = await _box;
    await box.add(password);
  }

  Future<void> updatePassword(Password password, oldPasswordIndex) async {
    final box = await _box;
    await box.put(oldPasswordIndex, password);
  }

  Future<void> deletePassword(Password password) async {
    final box = await _box;
    await box.deleteAt(box.values.toList().indexOf(password));
  }

  Future<List<Password>> getAllPasswords() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<List<String>> getAllPasswordHistory() async {
    final box = await _box;
    List<String> passwordHistory = [];
    for (var password in box.values) {
      passwordHistory.addAll(password.passwordHistory);
    }
    return passwordHistory;
  }
}
