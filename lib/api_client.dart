import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kumamite/secrets.dart';

class ApiClient {
  final String baseUrl;
  final secrets = Secrets();

  ApiClient({required this.baseUrl});

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/access-token'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': '',
        'username': username,
        'password': password,
        'scope': '',
        'client_id': '',
        'client_secret': '',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      String? accessToken = data['access_token']; // Store the access token
      print('Access Token: $accessToken');
      secrets.setAccessToken(accessToken);
      return true;
    } else {
      // throw Exception('Failed to log in: ${response.body}');
      print('ERROR: ${response.body}');
      return false;
    }
  }

  Future<dynamic> getInfo(String accessToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/info'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load info: ${response.body}');
    }
  }

  Future<dynamic> getMonitors(String accessToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/monitors/'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load monitors: ${response.body}');
    }
  }
}
