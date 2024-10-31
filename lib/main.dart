import 'package:flutter/material.dart';
import 'package:kumamite/api_client.dart';
import 'package:kumamite/secrets.dart';
import 'package:kumamite/pages/login.dart';
import 'package:kumamite/pages/splash.dart';
import 'package:kumamite/server_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? onboarding = await prefs.getBool('onboarding');
  onboarding ??= true;
  runApp(App(onboarding: onboarding));
}

class App extends StatelessWidget {
  const App({super.key, required this.onboarding});

  final bool onboarding;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kuma Mite',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF5CDD8B)),
        useMaterial3: true,
      ),
      // home: const HomePage(title: 'Uptime Mite'),
      debugShowCheckedModeBanner: false,
      home: onboarding ? const SplashScreen() : const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ApiClient apiClient;
  late Secrets secrets;
  late String baseUrl, accessToken;
  dynamic info, monitors;
  String errorMessage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    secrets = Secrets();
    Future.wait([
      secrets.getBaseUrl().then((response) {
        if (response != null) {
          setState(() {
            baseUrl = response;
          });
        } else {
          // TODO: Redirect to Server Screen
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ServerInfo()));
        }
      }),
      secrets.getAccessToken().then((response) {
        if (response != null) {
          setState(() {
            accessToken = response;
          });
        } else {
          // TODO: Redirect to login Screen
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()));
        }
      }),
    ]).then((_) {
      apiClient = ApiClient(baseUrl: baseUrl);
      fetchInfo();
      // fetchMonitors();
    });
  }

  Future<bool> isLoggedIn() async {
    return await secrets.getAccessToken() != null ? true : false;
  }

  void fetchInfo() async {
    try {
      bool loggedIn = await isLoggedIn();
      if (loggedIn) {
        final result = await apiClient.getInfo(accessToken);
        setState(() {
          info = result;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  void fetchMonitors() async {
    try {
      bool loggedIn = await isLoggedIn();
      if (loggedIn) {
        final result = await apiClient.getMonitors(accessToken);
        setState(() {
          monitors = result;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: errorMessage.isNotEmpty
              ? Center(child: Text('Error: $errorMessage'))
              : info != null
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Version: ${info['version']}'),
                          Text('Latest Version: ${info['latestVersion']}'),
                          Text('Is Container: ${info['isContainer']}'),
                          Text('Primary Base URL: ${info['primaryBaseURL']}'),
                          Text('Server Timezone: ${info['serverTimezone']}'),
                          Text(
                              'Server Timezone Offset: ${info['serverTimezoneOffset']}'),
                        ],
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
