import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kumamite/themes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ServerPage extends StatefulWidget {
  const ServerPage({super.key});

  @override
  State<ServerPage> createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();

  void _setServer() async {
    await storage.write(key: 'baseUrl', value: _controller.text);
  }

  bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  Future<void> _launchURL() async {
    final Uri url =
        Uri.parse('https://github.com/sannidhyaroy/Kuma-Mite/wiki/Get-Started');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // TODO: Handle errors gracefully
    }
  }

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
                  'Enter your Kuma API Server\'s address',
                  style: setupScreenHeader,
                ),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    style: setupScreenSubtitle,
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            'You\'ll need a RestAPI Server running alongside Kuma for this app to be able to communicate with it. ',
                      ),
                      TextSpan(
                        text: 'Read more.',
                        style: setupScreenLink,
                        recognizer: TapGestureRecognizer()..onTap = _launchURL,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      autofocus: true,
                      autofillHints: [AutofillHints.url],
                      controller: _controller,
                      cursorColor: setupScreenPrimaryColor,
                      decoration: const InputDecoration(
                        labelText: 'Kuma API Server Address',
                        hintText: 'https://api.kuma.pet',
                        border: UnderlineInputBorder(),
                      ),
                      style: setupInputFieldText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Server Address is required';
                        } else if (!(isValidUrl(value))) {
                          return 'Server Address is invalid';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                OutlinedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _setServer();
                      Navigator.of(context).pushNamed('/login');
                    }
                  },
                  style: setupNextButtonStyle,
                  child: setupNextButtonIcon,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
