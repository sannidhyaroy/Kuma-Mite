import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Secrets {
  final _storage = FlutterSecureStorage();

  // GET Methods
  Future<String?> getAccessToken() async {
    String? accessToken = await _storage.read(key: 'accessToken');
    return accessToken;
  }

  Future<String?> getBaseUrl() async {
    String? baseUrl = await _storage.read(key: 'baseUrl');
    return baseUrl;
  }

  // Set Methods
  Future<void> setAccessToken(String? accessToken) async {
    await _storage.write(key: 'accessToken', value: accessToken);
  }

  Future<void> setBaseUrl(String? baseUrl) async {
    await _storage.write(key: 'baseUrl', value: baseUrl);
  }
}
