import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class LocalStorage {
  Future<bool> setString(String key, String value);
  String? getString(String key);

  Future<void> saveSecureData(String key, String value);
  Future<String?> getSecureData(String key);
  Future<void> deleteSecureData(String key);

  Future<bool> remove(String key);
  Future<bool> clear();
}

class SharedPreferencesImpl implements LocalStorage {
  final SharedPreferences _sharedPreferences;
  final FlutterSecureStorage _secureStorage;

  SharedPreferencesImpl(this._sharedPreferences, this._secureStorage);

  static Future<SharedPreferencesImpl> create() async {
    final sharedPrefs = await SharedPreferences.getInstance();

    // Initialize FlutterSecureStorage with platform-specific options
    // For Android, use EncryptedSharedPreferences
    // For iOS, use Keychain with first unlock accessibility
    final secureStorage = FlutterSecureStorage(
      aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock
      ),
    );

    return SharedPreferencesImpl(sharedPrefs, secureStorage);
  }

  @override
  Future<bool> setString(final String key, final String value) {
    return _sharedPreferences.setString(key, value);
  }

  @override
  String? getString(final String key) {
    return _sharedPreferences.getString(key);
  }

  @override
  Future<void> saveSecureData(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> getSecureData(String key) async {
    return await _secureStorage.read(key: key);
  }

  @override
  Future<void> deleteSecureData(String key) async {
    await _secureStorage.delete(key: key);
  }

  @override
  Future<bool> remove(final String key) {
    return _sharedPreferences.remove(key);
  }

  @override
  Future<bool> clear() async {
    await _secureStorage.deleteAll();
    return _sharedPreferences.clear();
  }
}
