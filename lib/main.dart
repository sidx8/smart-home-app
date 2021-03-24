import 'package:flutter/material.dart';
import 'package:lumoshomes/Screens/addNewRoomScreen.dart';
import 'package:lumoshomes/Screens/authScreens/adminLogin.dart';
import 'package:lumoshomes/utils/constants.dart';
import 'package:lumoshomes/utils/wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xff0f1141),
        accentColor: Color(0xff16db83),
        scaffoldBackgroundColor: Color(0xfff0f0f0),
        dividerColor: Colors.transparent,
        appBarTheme: AppBarTheme(
            elevation: 8,
            color: Color(0xff0f1141),
            actionsIconTheme: IconThemeData(
              color: Colors.white,
              size: 24,
            )),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xff0f1141),
          hoverColor: Color(0xff3c4059),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Wrapper(),
      routes: {
        // RouteConstant.homeScreen: (context) => HomePage2(null),
        RouteConstant.adminScreen: (context) => AdminLogin(),
        // RouteConstant.adminHomePage: (context) => AdminHomePage(),
        RouteConstant.addRoomScreen: (context) => AddNewRoomScreen(),
      },
    );
  }
}
