import 'dart:convert';
import 'package:lumoshomes/models/devices.dart';

class Node {
  String id;
  String nodeId;
  int moduleType;
  List<Device> listOfDevices;

  Node({
    this.nodeId,
    this.id,
    this.moduleType,
    this.listOfDevices,
  });
  factory Node.fromJson(String str) => Node.fromMap(jsonDecode(str));

  String toJson() => jsonEncode(toMap());

  factory Node.fromMap(Map<String, dynamic> json) {
    // print('------------------------ node');
    List<Device> myDevice = List<dynamic>.from(json['listOfDevices'])
        .map((e) => e as Map)
        .map((e) => Map<String, dynamic>.from(e))
        .map((e) => Device.fromMap(e))
        .toList();

    return Node(
      id: json['id'],
      nodeId: json["nodeId"],
      moduleType: json["moduleType"],
      listOfDevices: json["listOfDevices"] == null ? null : myDevice,
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id ?? 'empty',
        "nodeId": nodeId,
        "moduleType": moduleType,
        "listOfDevices": List<Map<String, dynamic>>.from(
            listOfDevices.map((x) => x.toMap())),
      };
}
