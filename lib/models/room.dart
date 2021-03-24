import 'dart:convert';

import 'package:lumoshomes/models/node.dart';

class Room {
  String roomName;
  final bool state;
  final String roomId;
  final List<Node> listOfNodes;
  final String noOfDevices;
  Room({
    this.roomName,
    this.state,
    this.roomId,
    this.listOfNodes,
    this.noOfDevices,
  });
  factory Room.fromJson(String str) => Room.fromMap(jsonDecode(str));

  String toJson() => jsonEncode(toMap());

  factory Room.fromMap(Map<String, dynamic> json) {
    // print('reached room -------------------- ');
    // var jsonList = json['listOfNodes'];

    final myNodes = List<dynamic>.from((json['listOfNodes']));
    List<Node> nodes = myNodes
        .map((e) => e as Map)
        .map((e) => Map<String, dynamic>.from(e))
        .map((e) => Node.fromMap(e))
        .toList();
    // List<Map<String,dynamic>> mapOfNodes = myNodes.map((e) => Map<String,dynamic>.from(e)).toList();

    return Room(
      roomName: json["roomName"] == null ? null : json["roomName"],
      roomId: json["roomId"] == null ? null : json["roomId"],
      listOfNodes: json["listOfNodes"] == null ? null : nodes,
    );
  }

  Map<String, dynamic> toMap() => {
        "roomName": roomName == null ? null : roomName,
        "roomId": roomId == null ? null : roomId,
        "listOfNodes": listOfNodes == null
            ? null
            : List<Map<String, dynamic>>.from(
                listOfNodes.map((x) => x.toMap())),
      };
}

// List<Room> listOfRoom = [
//   Room(
//     listOfNodes: [
//       Node(listOfDevices: listOfDevicesAtHomePage, moduleType: 1, nodeId: "12")
//     ],
//     roomId: 'room1',
//     roomName: 'Bedroom',
//     state: false,
//     noOfDevices: '5',
//   ),
//   Room(
//     listOfNodes: [
//       Node(listOfDevices: listOfDevicesAtHomePage, moduleType: 1, nodeId: "15")
//     ],
//     roomId: 'room2',
//     roomName: 'Kitchen',
//     state: false,
//     noOfDevices: '3',
//   ),
//   Room(
//     listOfNodes: [
//       Node(listOfDevices: listOfDevicesAtHomePage, moduleType: 1, nodeId: "17")
//     ],
//     roomId: 'room3',
//     roomName: 'Bathroom',
//     state: false,
//     noOfDevices: '4',
//   ),
//   Room(
//     listOfNodes: [
//       Node(listOfDevices: listOfDevicesAtHomePage, moduleType: 1, nodeId: "17")
//     ],
//     roomId: 'room4',
//     roomName: 'Lobby',
//     state: false,
//     noOfDevices: '3',
//   ),
//   Room(
//     listOfNodes: [
//       Node(listOfDevices: listOfDevicesAtHomePage, moduleType: 1, nodeId: "17")
//     ],
//     roomId: 'room5',
//     roomName: 'Kids',
//     state: false,
//     noOfDevices: '2',
//   ),
// ];
