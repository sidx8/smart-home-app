import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lumoshomes/Providers/deviceProvider.dart';
import 'package:lumoshomes/Screens/SplashScreen.dart';
import 'package:lumoshomes/Screens/homepage/DevicePage.dart';
import 'package:lumoshomes/Screens/homepage/customTabBar.dart';
import 'package:lumoshomes/Screens/settings/settingsPage.dart';
import 'package:lumoshomes/services/databaseRepo.dart';
import 'package:lumoshomes/utils/common/heavyLoading.dart';
import 'package:lumoshomes/utils/constants.dart';
import 'package:lumoshomes/widgets/logoWidget.dart';
import 'package:mqtt_client/mqtt_client.dart' as Mqtt;
import 'package:mqtt_client/mqtt_server_client.dart' as MqttServer;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/room.dart';

class HomePage2 extends StatefulWidget {
  // This widget is the root of your application.
  // final List<Room> listOfRooms;
  HomePage2();
  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> with TickerProviderStateMixin {
  bool isSwitched = false;
  Future getRoomsFuture;
  List<Room> listOfRooms;
  bool _isOneTouchActive;
  String _routerValueDate;
  bool _isForceOfflineActive;

  // Mqtt.MqttClient client;
  MqttServer.MqttServerClient client;
  Mqtt.MqttClientConnectionStatus connectionState;
  // Future _initialFuture;
  // List<Widget> _listOfRoomPages;
  // TabController _tabController;
  // List<Tab> _tabListName;
  // List<Widget> _tabPages;

  initializeDatafromDatabase() async {
    final _prefs = await SharedPreferences.getInstance();
    _isOneTouchActive =
        _prefs.getBool(SettingConstants.ONE_TOUCH_SHUTDOWN_ISACTIVE) ?? true;
    _routerValueDate =
        _prefs.getString(SettingConstants.ROUTER_GATEWAY_VALUE) ?? '100';
    _isForceOfflineActive =
        _prefs.getBool(SettingConstants.FORCE_OFFLINE) ?? false;

    listOfRooms = await DatabaseRepo().getAllRooms();
    print('one touch value : $_isOneTouchActive');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context == null) return;
      Provider.of<DeviceProvider>(context, listen: false)
          .initializeRoomsToProvider(
              listOfRooms, _routerValueDate, _isForceOfflineActive);
    });
  }

  Color switchOffColor() {
    Color _mainColor;
    if (Provider.of<DeviceProvider>(context, listen: false).isInLocalNetwork) {
      _mainColor = Colors.red;
    } else {
      _mainColor = Theme.of(context).accentColor;
    }
    if (_isForceOfflineActive) {
      _mainColor = Colors.yellow;
    }
    return _mainColor;
  }

  @override
  void initState() {
    super.initState();
    // _initialFuture = initializeDatafromDatabase();
    // listOfRooms = widget.listOfRooms;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeDatafromDatabase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        } else
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              actions: [
                _isOneTouchActive
                    ? IconButton(
                        icon: Icon(Icons.power_settings_new),
                        iconSize: 35.0,
                        // color: Colors.red,
                        color: switchOffColor(),
                        onPressed: () {
                          print('Main power button pressed');
                          Provider.of<DeviceProvider>(context, listen: false)
                              .shutDownAllDevices();
                        },
                      )
                    : SizedBox(),
                IconButton(
                    icon: Icon(Icons.settings),
                    color: Colors.white,
                    iconSize: 35,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingPage(listOfRooms)));
                    }),

                // IconButton(
                //   icon: CircularProgressIndicator(),
                //   iconSize: 32,
                //   color: Colors.red,
                //   onPressed: () {
                //     print('Main power button pressed');
                //   },
                // ),
                Provider.of<DeviceProvider>(context).isLoading
                    ? IconButton(
                        icon: CircularProgressIndicator(),
                        iconSize: 32,
                        color: Theme.of(context).accentColor,
                        onPressed: () {},
                      )
                    : SizedBox(),
              ],
              // bottom: ColoredTabBar(
              //   color: Color(0xff111F4D),
              //   // color: Colors.white,
              //   tabBar: TabBar(
              //     controller: _tabController,
              //     labelPadding: EdgeInsets.symmetric(horizontal: 18),
              //     tabs: _tabListName,
              //     isScrollable: listOfRooms.length > 5 ? true : false ?? false,
              //   ),
              // ),
              title: Text(
                "Lumos Homes",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),

              leading: LogoWidget(),
            ),
            body: Consumer<DeviceProvider>(
              builder: (context, value, child) {
                String messageValue = value.isHeavyLoading;
                return Stack(children: [
                  child,
                  messageValue != null
                      ? Center(child: HeavyLoadingModal(message: messageValue))
                      : SizedBox()
                ]);
              },
              child: CustomTabViewWidget(roomList: listOfRooms ?? []),
            ),
          );
      },
    );
  }
}

class CustomTabViewWidget extends StatelessWidget {
  const CustomTabViewWidget({
    Key key,
    @required this.roomList,
  }) : super(key: key);
  final List<Room> roomList;

  @override
  Widget build(BuildContext context) {
    return CustomTabView(
      itemCount: roomList.length,
      tabBuilder: (context, index) => Tab(
          child: Text(
        "${roomList[index].roomName}",
        style: TextStyle(color: Colors.white),
      )),
      pageBuilder: (context, index) {
        return DevicePage(index);
      },
    );
  }
}
