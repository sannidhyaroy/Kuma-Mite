import 'package:flutter/material.dart';

class MonitorsTab extends StatelessWidget {
  const MonitorsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
