import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kumamite/pages/login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ServerInfo extends StatefulWidget {
  const ServerInfo({super.key});

  @override
  State<ServerInfo> createState() => _ServerInfoState();
}

class _ServerInfoState extends State<ServerInfo> {
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
    final Uri url = Uri.parse('https://github.com/sannidhyaroy/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // TODO: Handle errors gracefully
    }
  }

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
                'Enter your Kuma API Server\'s address',
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
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontFamily: 'Quicksand',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          'You\'ll need a RestAPI Server running alongside Kuma for this app to be able to communicate with it. ',
                    ),
                    TextSpan(
                      text: 'Read more.',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
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
                    decoration: const InputDecoration(
                      labelText: 'Kuma API Server Address',
                      hintText: 'https://api.kuma.pet',
                      border: UnderlineInputBorder(),
                    ),
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold,
                    ),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.black,
                  ),
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(5),
                ),
                child: Icon(
                  Icons.navigate_next,
                  color: Colors.black,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
