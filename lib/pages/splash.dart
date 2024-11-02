import 'package:flutter/material.dart';
import 'package:kumamite/themes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: lightTheme,
      child: Scaffold(
        backgroundColor: themeColor,
        body: SafeArea(
          child: Container(
            alignment: Alignment(0, 0),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Kuma Mite',
                  style: splashScreenHeader,
                ),
                const SizedBox(height: 5),
                Text(
                  'Let\'s get you connected with your Kuma instance',
                  style: splashScreenSubtitle,
                ),
                const SizedBox(height: 25),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/server');
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
