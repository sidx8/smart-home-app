class RouteConstant {
  static final homeScreen = '/homeScreen';
  static final adminScreen = '/adminScreen';
  static final addRoomScreen = '/addRoomsScreen';
  static final adminHomePage = '/adminHomeScreen';
}

enum DeviceType {
  ON_OFF_TYPE,
  FAN_TYPE,
  CURTAIN_TYPE,
  RGB_TYPE,
}

List<DeviceType> deviceListCONSTANTS = [
  DeviceType.ON_OFF_TYPE,
  DeviceType.FAN_TYPE,
  DeviceType.CURTAIN_TYPE,
  DeviceType.RGB_TYPE,
];

class SettingConstants {
  SettingConstants._();
  static const String FORCE_OFFLINE = 'force_offline';
  static const String IS_SCREEN_LOCK = 'isScreenLock';
  static const String SCREEN_LOCK_PASSWORD = 'screenLockPassword';
  static const String ONE_TOUCH_SHUTDOWN_ISACTIVE = 'isOneTouchShutdownActive';
  static const String ROUTER_GATEWAY_VALUE = 'routerGatewayValue';
}
