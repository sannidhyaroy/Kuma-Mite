import 'package:flutter/material.dart';
import 'api_client.dart';
import 'secrets.dart';
import 'package:kumamite/pages/splash.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

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
      home: const SplashScreen(),
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
        }
      }),
      secrets.getAccessToken().then((response) {
        if (response != null) {
          setState(() {
            accessToken = response;
          });
        } else {
          // TODO: Redirect to login Screen
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
