import 'package:flutter/material.dart';
import 'package:kumamite/main.dart';
import 'package:kumamite/api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5CDD8B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login to Uptime Kuma',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Raleway',
                  fontSize: 28,
                  fontVariations: [
                    FontVariation('wght', 600),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Authenticate using your Kuma API Credentials',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontFamily: 'Quicksand',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              AuthForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String username = '', password = '';
  bool isPressed = false;

  void _setCredentials() {
    username = _usernameController.text;
    password = _passwordController.text;
  }

  Future<bool> _getAccessToken() async {
    String? baseUrl = await storage.read(key: 'baseUrl');
    if (baseUrl == null) {
      // TODO: Prompt the User for Server Info
      return false;
    } else {
      //TODO: Authenticate and get access token
      final apiClient = ApiClient(baseUrl: baseUrl);
      final bool success = await apiClient.login(username, password);
      print(success);
      return success;
      // if (response.success!) {
      //   await storage.write(key: 'accessToken', value: response.body);
      // } else {
      //   // TODO: Report the error to the user
      //   // throw Exception(response.body);
      // }
      // return response.success!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              autofocus: false,
              autofillHints: const [
                "admin",
              ],
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'admin',
                border: UnderlineInputBorder(),
              ),
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Username is required';
                } else if (value != 'admin') {
                  return 'Potential incorrect username';
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
              autofocus: false,
              autofillHints: [AutofillHints.username],
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: '********',
                border: UnderlineInputBorder(),
              ),
              obscureText: true,
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password should not be empty';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 30,
            ),
            OutlinedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() && isPressed == false) {
                  setState(() {
                    isPressed = true;
                  });
                  _setCredentials();
                  if (await _getAccessToken()) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('onboarding', false);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (_) => false);
                  } else {
                    // TODO: Notify the user of login issues
                    setState(() {
                      isPressed = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('There was an error while logging in!'),
                      ),
                    );
                  }
                }
              },
              style: OutlinedButton.styleFrom(
                shape: isPressed
                    ? CircleBorder()
                    : RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                padding: isPressed
                    ? EdgeInsets.all(8)
                    : EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 8,
                      ),
                side: BorderSide(
                  color: Colors.black,
                ),
              ),
              child: isPressed
                  ? CircularProgressIndicator()
                  : const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Raleway',
                        fontVariations: [FontVariation("wght", 500)],
                        fontSize: 20,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
