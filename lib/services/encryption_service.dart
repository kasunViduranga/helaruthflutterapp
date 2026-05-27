import 'package:encrypt/encrypt.dart';

class EncryptionService {
  static final key = Key.fromUtf8('my32lengthsupersecretkey123'); // 32 chars
  static final iv = IV.fromLength(16); // 16 bytes IV
  static final encrypter = Encrypter(AES(key));

  static String encrypt(String text) {
    try {
      final encrypted = encrypter.encrypt(text, iv: iv);
      return encrypted.base64;
    } catch (e) {
      print('Encryption error: $e');
      return text; // Fallback
    }
  }

  static String decrypt(String encryptedText) {
    try {
      final encrypted = Encrypted.fromBase64(encryptedText);
      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      print('Decryption error: $e');
      return encryptedText; // Fallback
    }
  }
}