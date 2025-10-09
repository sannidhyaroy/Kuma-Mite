import 'package:flutter/material.dart';
import 'package:kumamite/api_client.dart';
import 'package:kumamite/secrets.dart';
import 'package:kumamite/routes.dart';
import 'package:kumamite/themes.dart';
import 'package:kumamite/pages/overview_tab.dart';
import 'package:kumamite/pages/monitors_tab.dart';
import 'package:kumamite/pages/statuspage_tab.dart';
import 'package:kumamite/pages/maintenance_tab.dart';
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
  final List<String> _tabNames = [
    'Overview',
    'Monitors',
    'Status Page',
    'Maintenance',
  ];
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
            StatusPageTab(),
            MaintenanceTab(),
          ][_navIndex],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        destinations: List.generate(_tabNames.length, (index) {
          return NavigationDestination(
            icon: Icon(_getTabIcon(index, false)),
            selectedIcon: Icon(_getTabIcon(index, true)),
            label: _tabNames[index],
          );
        }),
        onDestinationSelected: (int index) {
          setState(() {
            _navIndex = index;
          });
        },
      ),
    );
  }
}

IconData _getTabIcon(int index, bool isSelected) {
  switch (index) {
    case 0:
      return isSelected ? Icons.home_filled : Icons.home_outlined;
    case 1:
      return isSelected ? Icons.view_list : Icons.view_list_outlined;
    case 2:
      return isSelected ? Icons.amp_stories : Icons.amp_stories_outlined;
    case 3:
      return isSelected ? Icons.handyman : Icons.handyman_outlined;
    default:
      return Icons.help_outline;
  }
}
