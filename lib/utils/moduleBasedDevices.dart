import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lumoshomes/models/devices.dart';
import 'package:lumoshomes/utils/constants.dart';

class MyUtils {
  // light type module

  List<Device> _lightModule1 = [
    Device(
      deviceIcon: FontAwesomeIcons.lightbulb,
      deviceName: 'R1 light',
      deviceType: DeviceType.ON_OFF_TYPE,
      parameterId: 'relay1',
    )
  ];
  List<Device> _lightModule2 = [
    Device(
      deviceIcon: FontAwesomeIcons.lightbulb,
      deviceName: 'R1 light',
      deviceType: DeviceType.ON_OFF_TYPE,
      parameterId: 'relay1',
    ),
    Device(
      deviceIcon: FontAwesomeIcons.lightbulb,
      deviceName: 'R2 light',
      deviceType: DeviceType.ON_OFF_TYPE,
      parameterId: 'relay2',
    )
  ];
  List<Device> _lightModule3 = [
    Device(
      deviceIcon: FontAwesomeIcons.lightbulb,
      deviceName: 'R1 light',
      deviceType: DeviceType.ON_OFF_TYPE,
      parameterId: 'relay1',
    ),
    Device(
      deviceIcon: FontAwesomeIcons.lightbulb,
      deviceName: 'R2 light',
      deviceType: DeviceType.ON_OFF_TYPE,
      parameterId: 'relay2',
    ),
    Device(
      deviceIcon: FontAwesomeIcons.lightbulb,
      deviceName: 'R3 light',
      deviceType: DeviceType.ON_OFF_TYPE,
      parameterId: 'relay3',
    ),
  ];
  List<Device> _lightModule4 = [
    Device(
      deviceIcon: FontAwesomeIcons.lightbulb,
      deviceName: 'R1 light',
      deviceType: DeviceType.ON_OFF_TYPE,
      parameterId: 'relay1',
    ),
    Device(
      deviceIcon: FontAwesomeIcons.lightbulb,
      deviceName: 'R2 light',
      deviceType: DeviceType.ON_OFF_TYPE,
      parameterId: 'relay2',
    ),
    Device(
      deviceIcon: FontAwesomeIcons.lightbulb,
      deviceName: 'R3 light',
      deviceType: DeviceType.ON_OFF_TYPE,
      parameterId: 'relay3',
    ),
    Device(
      deviceIcon: FontAwesomeIcons.lightbulb,
      deviceName: 'R4 light',
      deviceType: DeviceType.ON_OFF_TYPE,
      parameterId: 'relay4',
    ),
  ];

  // ac  type module --------------------------------------------------
  List<Device> _acModule = [
    Device(
        deviceIcon: FontAwesomeIcons.wind,
        parameterId: 'relay1',
        deviceName: 'R1 AC',
        deviceType: DeviceType.ON_OFF_TYPE),
  ];
  // curtain type module --------------------------------------------------

  List<Device> _curtainModule = [
    Device(
        deviceIcon: FontAwesomeIcons.doorOpen,
        parameterId: 'relay1',
        deviceName: 'R1 Curtain',
        deviceType: DeviceType.CURTAIN_TYPE),
  ];
  // range type module -------------------------------------- FAN ------------

  List<Device> _fanModule1 = [
    Device(
      deviceIcon: FontAwesomeIcons.fan,
      parameterId: 'relay1',
      deviceName: 'R1 Fan',
      deviceType: DeviceType.FAN_TYPE,
    ),
  ];
  List<Device> _fanModule2 = [
    Device(
      deviceIcon: FontAwesomeIcons.fan,
      parameterId: 'relay1',
      deviceName: 'R1 Fan',
      deviceType: DeviceType.FAN_TYPE,
    ),
    Device(
      deviceIcon: FontAwesomeIcons.fan,
      parameterId: 'relay2',
      deviceName: 'R2 Fan',
      deviceType: DeviceType.FAN_TYPE,
    ),
  ];
  // range type module -------------------------------------- RBG ------------

  List<Device> _rgbModule1 = [
    Device(
      deviceIcon: FontAwesomeIcons.rainbow,
      parameterId: 'relay1',
      deviceName: 'R1 RGB',
      deviceType: DeviceType.RGB_TYPE,
    ),
  ];
  List<Device> _rgbModule2 = [
    Device(
      deviceIcon: FontAwesomeIcons.rainbow,
      parameterId: 'relay1',
      deviceName: 'R1 RGB',
      deviceType: DeviceType.RGB_TYPE,
    ),
    Device(
      deviceIcon: FontAwesomeIcons.rainbow,
      parameterId: 'relay2',
      deviceName: 'R2 RGB',
      deviceType: DeviceType.RGB_TYPE,
    ),
  ];

  // svg of devices modules -----------------------------------

  String getAssetsByMODULE(int moduleNo) {
    final String assetConst = 'assets/images/';
    String lightBulbAsset = assetConst + "ledlamp.svg";
    String rgbColorAssets = assetConst + "rgb.svg";
    String curtainsAssets = assetConst + "curtains.svg";
    String acAssets = assetConst + "airconditioner.svg";

    String fanAssets = assetConst + "fan.svg";

    switch (moduleNo) {
      case 0:
        return lightBulbAsset;
        break;
      case 1:
        return lightBulbAsset;
        break;
      case 2:
        return lightBulbAsset;
        break;
      case 3:
        return lightBulbAsset;
        break;

      case 4:
        return acAssets;
        break;

      case 5:
        return fanAssets;
        break;
      case 6:
        return fanAssets;
        break;
      case 7:
        return rgbColorAssets;
        break;
      case 8:
        return rgbColorAssets;
        break;
      case 9:
        return curtainsAssets;
        break;

      default:
        return lightBulbAsset;
    }
  }

  // svg of devices modules -----------------------------------

  IconData getIconsByMODULE(int moduleNo) {
    switch (moduleNo) {
      case 0:
        return FontAwesomeIcons.lightbulb;
        break;
      case 1:
        return FontAwesomeIcons.lightbulb;
        break;
      case 2:
        return FontAwesomeIcons.lightbulb;
        break;
      case 3:
        return FontAwesomeIcons.lightbulb;
        break;

      case 4:
        return FontAwesomeIcons.wind;
        break;

      case 5:
        return FontAwesomeIcons.fan;
        break;
      case 6:
        return FontAwesomeIcons.fan;
        break;
      case 7:
        return FontAwesomeIcons.rainbow;
        break;
      case 8:
        return FontAwesomeIcons.rainbow;
        break;
      case 9:
        return FontAwesomeIcons.doorOpen;
        break;

      default:
        return Icons.error;
    }
  }

  //  switch (value) {
  //     case 0:
  //       return _lightModule1;
  //       break;
  //     case 1:
  //       return _acModule;
  //       break;
  //     case 2:
  //       return _fanModule;
  //       break;
  //     case 3:
  //       return _rgbModule;
  //       break;
  //     case 4:
  //       return _curtainModule;
  //       break;

  List<Device> moduleType(int value) {
    switch (value) {

//-------------- light ----------------------

      case 0:
        return _lightModule1;
        break;
      case 1:
        return _lightModule2;
        break;
      case 2:
        return _lightModule3;
        break;
      case 3:
        return _lightModule4;
        break;
//-------------- ac ----------------------

      case 4:
        return _acModule;
        break;
//-------------- fan ----------------------

      case 5:
        return _fanModule1;
        break;
      case 6:
        return _fanModule2;
        break;
//-------------- rgb ----------------------

      case 7:
        return _rgbModule1;
        break;
      case 8:
        return _rgbModule2;
        break;

//-------------- curtains ----------------------
      case 9:
        return _curtainModule;
        break;

      default:
        return [];
    }
  }
}
