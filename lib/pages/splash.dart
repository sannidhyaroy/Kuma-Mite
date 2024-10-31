import 'package:flutter/material.dart';
import 'package:kumamite/server_info.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5CDD8B),
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
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Raleway',
                  fontSize: 25,
                  fontVariations: [
                    FontVariation('wght', 700),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Let\'s get you connected with your Kuma instance',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontFamily: 'Quicksand',
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 25),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ServerInfo()));
                },
                style: ElevatedButton.styleFrom(
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
