import 'package:flutter/material.dart';
import 'package:lumoshomes/Screens/settings/accountPage.dart';
import 'package:lumoshomes/Screens/settings/RoomAndDevicePage.dart';
import 'package:lumoshomes/models/room.dart';
import 'package:lumoshomes/services/authService.dart';
import 'package:lumoshomes/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  final List<Room> roomdata;
  SettingPage(this.roomdata);
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isScreenLocked = false;
  bool isTouchShutdownActive = false;
  String routerValueDate;
  List<Room> roomdata;

  TextEditingController _password;
  TextEditingController _routerGatewayValue;
  String lockPassword = '123';
  bool forceOffline = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  getPreferencesValues() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      forceOffline = prefs.getBool(SettingConstants.FORCE_OFFLINE) ?? false;
      lockPassword = prefs.getString(SettingConstants.SCREEN_LOCK_PASSWORD);
      routerValueDate =
          prefs.getString(SettingConstants.ROUTER_GATEWAY_VALUE) ?? null;
      isTouchShutdownActive =
          prefs.getBool(SettingConstants.ONE_TOUCH_SHUTDOWN_ISACTIVE) ?? true;
      isScreenLocked = prefs.getBool(SettingConstants.IS_SCREEN_LOCK) ?? false;
    });
    print('is Screen lock : $lockPassword');
  }

  @override
  void initState() {
    _password = TextEditingController();
    _routerGatewayValue = TextEditingController();
    getPreferencesValues();
    super.initState();
  }

  settingListItem(IconData icon, String title, Function onPressed,
      {Widget tralingWidget}) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        margin: EdgeInsets.only(left: 8, right: 8, top: 8),
        //   color: Colors.grey[900],
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: ListTile(
            leading: Icon(
              icon,
              size: 32,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500),
            ),
            trailing: tralingWidget ?? SizedBox(),
          ),
        ),
      ),
    );
  }

  showCustomDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are You Sure'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                'Yes',
                style: TextStyle(fontSize: 16),
              )),
          TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                'cancle',
                style: TextStyle(fontSize: 16),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        // margin: EdgeInsets.all(8),
        child: ListView(
          children: [
            settingListItem(
              Icons.account_box,
              "Account",
              () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AccountPage()));
              },
            ),
            Divider(
              color: Colors.blueGrey,
              height: 0,
              thickness: 0.5,
            ),
            Container(
              margin: EdgeInsets.only(
                left: 8,
                right: 8,
                bottom: 5,
                top: 12,
              ),
              //  color: Colors.grey[400],
              child: ExpansionTile(
                backgroundColor: Colors.grey[200],
                leading: Icon(
                  Icons.phonelink_lock,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
                initiallyExpanded: isScreenLocked,
                trailing: Icon(
                  Icons.arrow_drop_down,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
                title: Row(
                  children: [
                    Text(
                      'Screen Lock',
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                    Switch(
                        value: isScreenLocked,
                        onChanged: (value) async {
                          SharedPreferences prefs = await _prefs;
                          prefs.setBool(SettingConstants.IS_SCREEN_LOCK, value);
                          print('screen lock state saved');
                          setState(() {
                            isScreenLocked = value;
                            print('isScreenLocked = $isScreenLocked');
                          });
                        }),
                  ],
                ),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.only(top: 10),
                        height: 60,
                        width: 200,
                        child: TextField(
                          controller: _password,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter Password',
                          ),
                        ),
                      ),
                      FlatButton(
                        textColor: Colors.white,
                        color: Colors.blueGrey,
                        onPressed: () async {
                          SharedPreferences prefs = await _prefs;
                          if (_password.text != null &&
                              _password.text.isNotEmpty) {
                            setState(() {
                              prefs.setString(
                                  SettingConstants.SCREEN_LOCK_PASSWORD,
                                  _password.text);
                              lockPassword = _password.text;
                            });
                            print('password set: $lockPassword');
                          }
                        },
                        child: Text('Save'),
                      ),
                    ],
                  ),
                  Text('Your Current Passowrd is:  $lockPassword'),
                ],
              ),
            ),
            Divider(
              color: Colors.blueGrey,
              height: 0,
              thickness: 0.5,
            ),
            settingListItem(
                Icons.power_settings_new, "One Touch ShutDown", () {},
                tralingWidget: Switch(
                    value: isTouchShutdownActive,
                    onChanged: (value) async {
                      SharedPreferences prefs = await _prefs;
                      prefs.setBool(
                          SettingConstants.ONE_TOUCH_SHUTDOWN_ISACTIVE, value);
                      setState(() {
                        isTouchShutdownActive = value;

                        print(isTouchShutdownActive);
                      });
                    })),
            Divider(
              color: Colors.blueGrey,
              height: 0,
              thickness: 0.5,
            ),
            settingListItem(Icons.settings, "Room and Device Setting", () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RoomSettings()));
            }),
            Divider(
              color: Colors.blueGrey,
              height: 0,
              thickness: 0.5,
            ),
            settingListItem(Icons.help, "Help", () {}),
            settingListItem(Icons.offline_bolt, "Force Offline", () {},
                tralingWidget: Switch(
                    value: forceOffline,
                    onChanged: (value) async {
                      SharedPreferences prefs = await _prefs;
                      prefs.setBool(SettingConstants.FORCE_OFFLINE, value);
                      setState(() {
                        forceOffline = value;

                        print(forceOffline);
                      });
                    })),
            settingListItem(Icons.router, "R", () {},
                tralingWidget: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.only(top: 10),
                      // height: 60,
                      width: 100,
                      child: TextField(
                        controller: _routerGatewayValue,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'router',
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    FlatButton(
                      textColor: Colors.white,
                      color: Colors.blueGrey,
                      onPressed: () async {
                        SharedPreferences prefs = await _prefs;
                        var routerValue = _routerGatewayValue.text;
                        if (routerValue != null &&
                            routerValue.isNotEmpty &&
                            int.parse(routerValue) < 256) {
                          setState(() {
                            prefs.setString(
                                SettingConstants.ROUTER_GATEWAY_VALUE,
                                routerValue);
                            routerValueDate = routerValue;
                            // lockPassword = routerValue;
                          });
                          print('value set: $routerValue');
                        }
                      },
                      child: Text(routerValueDate ?? 'no value'),
                    ),
                  ],
                )),
            Divider(
              color: Colors.blueGrey,
              height: 0,
              thickness: 0.5,
            ),
            settingListItem(
              Icons.exit_to_app,
              "Logout",
              () => logoutFunction(context),
            ),
          ],
        ),
      ),
    );
  }

  logoutFunction(BuildContext context) async {
    bool isLogout = await showCustomDialog(context);
    if (isLogout ?? false) {
      AuthService().signout();
      Navigator.pop(context);
    }
  }
}
