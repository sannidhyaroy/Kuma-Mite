import 'package:flutter/material.dart';
import 'package:kumamite/main.dart';
import 'package:kumamite/pages/login.dart';
import 'package:kumamite/pages/splash.dart';
import 'package:kumamite/pages/server_info.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => HomePage(),
  '/splash': (context) => SplashScreen(),
  '/server': (context) => ServerInfo(),
  '/login': (context) => LoginPage(),
};
