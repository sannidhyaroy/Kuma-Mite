import 'package:flutter/material.dart';
import 'package:kumamite/api_client.dart';
import 'package:kumamite/secrets.dart';
import 'package:kumamite/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Secrets secrets = Secrets();
  bool onboarding = prefs.getBool('onboarding') ?? true;
  String baseUrl = await secrets.getBaseUrl() ?? '';
  String accessToken = await secrets.getAccessToken() ?? '';
  runApp(App(
    onboarding: onboarding,
    baseUrl: baseUrl,
    accessToken: accessToken,
  ));
}

class App extends StatelessWidget {
  const App(
      {super.key,
      required this.onboarding,
      required this.baseUrl,
      required this.accessToken});

  final bool onboarding;
  final String baseUrl, accessToken;

  String _getInitialRoute() {
    return onboarding
        ? '/splash'
        : (baseUrl.isEmpty
            ? '/server'
            : (accessToken.isEmpty ? '/login' : '/'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kuma Mite',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF5CDD8B)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: _getInitialRoute(),
      routes: routes,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiClient apiClient = ApiClient();
  dynamic info, monitors;
  String errorMessage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchInfo();
  }

  Future<void> fetchInfo() async {
    try {
      final result = await apiClient.getInfo();
      setState(() {
        info = result;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  Future<void> fetchMonitors() async {
    try {
      final result = await apiClient.getMonitors();
      setState(() {
        monitors = result;
      });
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
