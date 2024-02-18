import 'dart:math';

class BasicHelpers {
  static String generatePassword(int characterLength, bool includeUpperCase,
      bool includeNumbers, bool includeSymbols) {
    // Tanımlanan karakter setleri
    final List<String> upperCaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
    final List<String> lowerCaseChars = 'abcdefghijklmnopqrstuvwxyz'.split('');
    final List<String> numbers = '0123456789'.split('');
    final List<String> symbols = '~!@#\$%^&*()_-+={[}]|:;"<,>.?/'.split('');

    // Karakterlerin hepsini içerecek olan karakter seti
    List<String> allCharacters = List<String>.from(lowerCaseChars);

    // Büyük harfleri ekle
    if (includeUpperCase) {
      allCharacters.addAll(upperCaseChars);
    }

    // Sayıları ekle
    if (includeNumbers) {
      allCharacters.addAll(numbers);
    }

    // Sembolleri ekle
    if (includeSymbols) {
      allCharacters.addAll(symbols);
    }

    // Rastgele karaterler seçerek şifre oluştur
    String password = '';
    final random = Random();
    for (int i = 0; i < characterLength; i++) {
      password += allCharacters[random.nextInt(allCharacters.length)];
    }

    return password;
  }
}
