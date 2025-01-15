import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract final class SecureStorage {
  static const _emailKey = 'email';
  static const _passwordKey = 'password';

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static Future<void> saveEmail(String email) async {
    return _storage.write(key: _emailKey, value: email);
  }

  static Future<String?> get email {
    return _storage.read(key: _emailKey);
  }

  static Future<void> savePassword(String password) async {
    return _storage.write(key: _passwordKey, value: password);
  }

  static Future<String?> get password {
    return _storage.read(key: _passwordKey);
  }

  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
