import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      // height: 50,
      // width: 50,
      child: Image.asset(
        'assets/images/icon.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
