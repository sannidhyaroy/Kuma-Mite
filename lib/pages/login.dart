import 'package:flutter/material.dart';
import 'package:kumamite/api_client.dart';
import 'package:kumamite/themes.dart';
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
    return Theme(
      data: lightTheme,
      child: Scaffold(
        backgroundColor: themeColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login to Uptime Kuma',
                  style: setupScreenHeader,
                ),
                const SizedBox(height: 5),
                Text(
                  'Authenticate using your Kuma API Credentials',
                  style: setupScreenSubtitle,
                ),
                const SizedBox(height: 25),
                AuthForm(),
              ],
            ),
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
  final _storage = FlutterSecureStorage();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _username = '', _password = '';
  bool _isPressed = false, _showPassword = false;

  void _setCredentials() {
    _username = _usernameController.text;
    _password = _passwordController.text;
  }

  Future<bool> _getAccessToken() async {
    String? baseUrl = await _storage.read(key: 'baseUrl');
    if (baseUrl == null) {
      // TODO: Prompt the User for Server Info
      return false;
    } else {
      //TODO: Authenticate and get access token
      final apiClient = ApiClient();
      final bool success = await apiClient.login(_username, _password);
      return success;
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
              cursorColor: setupScreenPrimaryColor,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'admin',
                border: UnderlineInputBorder(),
              ),
              style: setupInputFieldText,
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
              autofillHints: [AutofillHints.password],
              controller: _passwordController,
              cursorColor: setupScreenPrimaryColor,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: '********',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off),
                ),
                border: const UnderlineInputBorder(),
              ),
              obscureText: !_showPassword,
              style: setupInputFieldText,
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
                if (_formKey.currentState!.validate() && _isPressed == false) {
                  setState(() {
                    _isPressed = true;
                  });
                  _setCredentials();
                  if (await _getAccessToken()) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('onboarding', false);
                    if (context.mounted) {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/', (_) => false);
                    }
                  } else {
                    // TODO: Notify the user of login issues
                    setState(() {
                      _isPressed = false;
                    });
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('There was an error while logging in!'),
                        ),
                      );
                    }
                  }
                }
              },
              style: _isPressed ? loginProgressButtonStyle : loginButtonStyle,
              child: _isPressed
                  ? CircularProgressIndicator()
                  : Text(
                      'Login',
                      style: setupButtonText,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
