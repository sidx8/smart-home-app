import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                'Welcome to Lumos Homes',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
              ),
            ),
            // Loading()
          ],
        ),
      ),
    );
  }
}
