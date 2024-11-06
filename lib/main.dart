import 'package:flutter/material.dart';
import 'package:kumamite/api_client.dart';
import 'package:kumamite/secrets.dart';
import 'package:kumamite/routes.dart';
import 'package:kumamite/themes.dart';
import 'package:kumamite/pages/overview_tab.dart';
import 'package:kumamite/pages/monitors_tab.dart';
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
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
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
  dynamic info;
  String infoErrorMessage = '';
  final List<String> _tabNames = ['Overview', 'Monitors'];
  int _navIndex = 0;

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
        infoErrorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabNames[_navIndex]),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: [
            OverviewTab(
              errorMessage: infoErrorMessage,
              info: info,
            ),
            MonitorsTab(),
          ][_navIndex],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_filled),
            label: _tabNames[0],
          ),
          NavigationDestination(
            icon: Icon(Icons.view_list_outlined),
            selectedIcon: Icon(Icons.view_list),
            label: _tabNames[1],
          ),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            _navIndex = index;
          });
        },
      ),
    );
  }
}
