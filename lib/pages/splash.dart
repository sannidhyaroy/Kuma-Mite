import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kumamite/themes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: setupTheme,
      child: Scaffold(
        backgroundColor: setupScreenThemeColor,
        body: SafeArea(
          child: Container(
            alignment: Alignment(0, 0),
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: SplashItems(),
          ),
        ),
      ),
    );
  }
}

class SplashItems extends StatelessWidget {
  const SplashItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/Cat_Sleeping.svg',
          height: 200,
        ),
        const SizedBox(height: 5),
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
          style: setupNextButtonStyle(context),
          child: setupNextButtonIcon,
        ),
      ],
    );
  }
}
