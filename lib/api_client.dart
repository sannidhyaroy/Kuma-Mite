import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kumamite/secrets.dart';

class ApiClient {
  final secrets = Secrets();

  Future<bool> login(String username, String password) async {
    String baseUrl = await secrets.getBaseUrl() ?? '';
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
      final data = json.decode(response.body) as Map<String, dynamic>;
      String? accessToken = data['access_token']; // Store the access token
      print('Access Token: $accessToken');
      secrets.setAccessToken(accessToken);
      return true;
    } else {
      // throw Exception(response.body);
      print('ERROR: ${response.body}');
      return false;
    }
  }

  Future<Map<String, dynamic>> getInfo() async {
    String? baseUrl = await secrets.getBaseUrl();
    String? accessToken = await secrets.getAccessToken();
    if (baseUrl == null) {
      throw BaseUrlException();
    }
    if (accessToken == null) {
      throw AccessTokenException();
    }
    final response = await http.get(
      Uri.parse('$baseUrl/info'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      if (needReLogin(response)) {
        throw AccessTokenException();
      } else if (hasConnectionTimedOut(response)) {
        throw TimeOutException();
      } else {
        throw http.ClientException(response.body);
      }
    }
  }

  Future<Map<String, dynamic>> getMonitors() async {
    String? baseUrl = await secrets.getBaseUrl();
    String? accessToken = await secrets.getAccessToken();
    if (baseUrl == null) {
      throw BaseUrlException();
    }
    if (accessToken == null) {
      throw AccessTokenException();
    }
    final response = await http.get(
      Uri.parse('$baseUrl/monitors/'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      if (needReLogin(response)) {
        throw AccessTokenException();
      } else if (hasConnectionTimedOut(response)) {
        throw TimeOutException();
      } else {
        throw http.ClientException(response.body);
      }
    }
  }

  Future<Map<String, dynamic>> getBeats({required int monitorId}) async {
    String? baseUrl = await secrets.getBaseUrl();
    String? accessToken = await secrets.getAccessToken();
    if (baseUrl == null) {
      throw BaseUrlException();
    }
    if (accessToken == null) {
      throw AccessTokenException();
    }
    final response = await http.get(
      Uri.parse('$baseUrl/monitors/$monitorId/beats'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      if (needReLogin(response)) {
        throw AccessTokenException();
      } else if (hasConnectionTimedOut(response)) {
        throw TimeOutException();
      } else {
        throw http.ClientException(response.body);
      }
    }
  }

  bool needReLogin(http.Response response) {
    return jsonDecode(response.body)['detail'] == 'invalid credentials';
  }

  bool hasConnectionTimedOut(http.Response response) {
    return jsonDecode(response.body)['detail'] ==
        'Timed out while waiting for event info';
  }
}

class BaseUrlException implements Exception {
  String? cause;

  BaseUrlException([this.cause]);

  @override
  String toString() {
    if (cause == null) {
      return 'Server Address is not set. Set a valid url for the API Server';
    }
    return cause!;
  }
}

class AccessTokenException implements Exception {
  String? cause;

  AccessTokenException([this.cause]);

  @override
  String toString() {
    if (cause == null) {
      return 'Your Access Token is either not set or has expired. Login to the API Server to generate an access token';
    }
    return cause!;
  }
}

class TimeOutException implements Exception {
  String? cause;

  TimeOutException([this.cause]);

  @override
  String toString() {
    if (cause == null) {
      return 'Your connection timed out while waiting for event info. Please check your internet connection and try again.';
    }
    return cause!;
  }
}
