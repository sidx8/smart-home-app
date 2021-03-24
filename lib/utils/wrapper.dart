import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lumoshomes/Providers/deviceProvider.dart';
import 'package:lumoshomes/Screens/SplashScreen.dart';
import 'package:lumoshomes/Screens/authScreens/login.dart';
import 'package:lumoshomes/Screens/homepage/homePage.dart';
import 'package:lumoshomes/Screens/settings/ScreenLock.dart';
import 'package:lumoshomes/models/room.dart';
import 'package:lumoshomes/services/authService.dart';
import 'package:lumoshomes/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool lockState;
  String lockPassword;
  bool isOneTouchActive;

  getlockstate() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    lockState = _prefs.getBool(SettingConstants.IS_SCREEN_LOCK);
    lockPassword = _prefs.getString(SettingConstants.SCREEN_LOCK_PASSWORD);
    isOneTouchActive =
        _prefs.getBool(SettingConstants.ONE_TOUCH_SHUTDOWN_ISACTIVE);
  }

  @override
  void initState() {
    super.initState();

    getlockstate();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return StreamBuilder(
              stream: AuthService().user,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SplashScreen();
                } else {
                  User user = snapshot.data;
                  print('user is null : ${user == null}');
                  print('email verified : ${user?.emailVerified}');

                  if (user != null && user.emailVerified) {
                    return FutureBuilder(
                        future: AuthService().checkDatabaseAvailability(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SplashScreen();
                          } else {
                            List<Room> locallySavedListOfRooms = snapshot.data;
                            if (locallySavedListOfRooms != null) {
                              if ((lockState ?? false) &&
                                  (lockPassword != null)) {
                                return ScreenLock(lockPassword);
                              } else {
                                return ChangeNotifierProvider(
                                  create: (context) => DeviceProvider(),
                                  child: Container(
                                    child: HomePage2(),
                                  ),
                                );
                              }
                            } else
                              return LoginPage();
                          }
                        });
                  } else {
                    print('data is null : ${snapshot.data} ');
                    return LoginPage();
                  }
                }
              },
            );
          }
        });
  }
}
