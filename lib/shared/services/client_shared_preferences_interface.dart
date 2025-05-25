import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class IClientSharedPreferences {
  Future<String?> get(String key);
  Future<void> set<T>(String key, T value);
  Future<void> clean(String key);
  Future<bool> containsKey(String key);
}

class ClientSharedPreferences implements IClientSharedPreferences {
  final FlutterSecureStorage _storage;

  ClientSharedPreferences._(this._storage);

  static Future<ClientSharedPreferences> init() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    return ClientSharedPreferences._(storage);
  }

  @override
  Future<String?> get(String key) {
    return _storage.read(key: key, iOptions: _getIOSOptions, aOptions: _getAndroidOptions);
  }

  @override
  Future<void> set<T>(String key, T value) async {
    return _storage.write(key: key, value: value as String, iOptions: _getIOSOptions, aOptions: _getAndroidOptions);
  }

  @override
  Future<void> clean(String key) async {
    return _storage.delete(key: key, iOptions: _getIOSOptions, aOptions: _getAndroidOptions);
  }

  @override
  Future<bool> containsKey(String key) {
    return _storage.containsKey(key: key, iOptions: _getIOSOptions, aOptions: _getAndroidOptions);
  }

  IOSOptions get _getIOSOptions => const IOSOptions();

  AndroidOptions get _getAndroidOptions => const AndroidOptions(encryptedSharedPreferences: true);
}
