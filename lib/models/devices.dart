import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lumoshomes/utils/constants.dart';

class Device {
  String deviceName;
  String deviceRoom;
  IconData deviceIcon;
  String deviceId;

  String iconAsset;

  final DeviceType deviceType; // on/off or range 0 - 255

  bool deviceState; // 0 or 1
  String nodeNo; // like http://192.168.100.[45] => here 45 is nodeNo
  String parameterId; // like relay1 , relay2 etc.

  int currentValue;

  Device({
    @required this.deviceName,
    this.iconAsset,
    this.deviceIcon,
    this.deviceId, // *
    this.deviceRoom, // *
    this.deviceState = false,
    this.deviceType,
    this.currentValue,
    @required this.parameterId,
    this.nodeNo, // *
  });
  factory Device.fromJson(String str) => Device.fromMap(jsonDecode(str));

  String toJson() => jsonEncode(toMap());

  factory Device.fromMap(Map<String, dynamic> json) {
    return Device(
        deviceName: json["deviceName"] ?? 'noDeviceName',
        deviceRoom: json["deviceRoom"] ?? 'noDeviceRoom',
        deviceId: json["deviceId"] ?? 'noDeviceId',
        deviceType: deviceListCONSTANTS[json['inputType']],
        parameterId: json["parameterId"],
        nodeNo: json["nodeNo"]);
  }

  Map<String, dynamic> toMap() => {
        "deviceName": deviceName,
        "deviceRoom": deviceRoom,
        "deviceId": deviceId,
        "inputType": deviceListCONSTANTS.indexOf(deviceType),
        "parameterId": parameterId,
        "nodeNo": nodeNo,
        // "devicePosition": devicePosition,
      };
}

// List<Device> _listOfDevicesAtHomePage = [
//   Device(
//       deviceIcon: FontAwesomeIcons.lightbulb,
//       deviceName: 'Light',
//       deviceRoom: 'BedRoom',
//       deviceId: 'node1',
//       nodeNo: "1",
//       parameterId: "relay1"),
//   Device(
//       deviceIcon: FontAwesomeIcons.fan,
//       deviceName: 'Fan',
//       deviceRoom: 'BedRoom',
//       deviceId: 'node2',
//       nodeNo: "2",
//       parameterId: "relay2"),
//   Device(
//       deviceIcon: FontAwesomeIcons.lightbulb,
//       deviceName: 'Light 2',
//       deviceRoom: 'Mom\'s Room',
//       deviceId: 'node3',
//       nodeNo: "3",
//       parameterId: "relay3"),
//   Device(
//       deviceIcon: FontAwesomeIcons.bars,
//       deviceName: 'Curtains',
//       deviceRoom: 'Hall',
//       deviceId: 'node4',
//       nodeNo: "4",
//       parameterId: "relay4"),
// ];
