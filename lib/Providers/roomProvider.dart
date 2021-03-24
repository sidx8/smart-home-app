import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:lumoshomes/models/node.dart';
import 'package:lumoshomes/models/room.dart';

class RoomProvider extends ChangeNotifier {
  List<Node> _listOfSavedNodes;
  List<Node> _listOfNodeWidgets;
  List<Room> _listOfRooms;

  RoomProvider({List<Node> listOfNode}) {
    print('room provider called !');
    if (listOfNode != null) {
      _listOfSavedNodes = [...listOfNode];
      _listOfNodeWidgets = [...listOfNode];
    } else {
      _listOfSavedNodes = [];
      _listOfNodeWidgets = [];
      print('provider data <null>');
    }
    _listOfRooms = [];
  }

  List<Node> get listOfnodesWidget => _listOfNodeWidgets;
  List<Room> get getListOfRooms => _listOfRooms;
  List<Node> get getListOfNodes => [..._listOfSavedNodes];

  setListOfRooms(List<Room> myRoomList) {
    _listOfRooms = myRoomList;
    notifyListeners();
  }

  setASpecificRoom(Room specificRoom) {
    // _listOfSavedNodes.clear();
    // _listOfSavedNodes.addAll(specificRoom.listOfNodes);

    // specificRoom.listOfNodes.forEach((element) {
    //   saveNode(element);
    // });
  }

  addNewNode(Node node) {
    _listOfNodeWidgets.add(node);
    // print('node id: ${node.id}');
    // print('list of nodes : ${_listOfNodeWidgets.length}');
    // print('list of saved nodes : ${_listOfSavedNodes.length}');
    notifyListeners();
  }

  removeNode(Node node) {
    _listOfNodeWidgets.removeWhere((element) {
      print(' check : ${node.id}');
      if (element.id == node.id) {
        print('element found at: ${element.id}');
        return true;
      }
      return false;
    });
    _listOfSavedNodes.removeWhere((element) => element.nodeId == node.nodeId);
    notifyListeners();
  }

  bool saveNode(Node node) {
    bool sameIdCheck = false;
    // adding deviceId and nodeNo

    node.listOfDevices.forEach((element) {
      element.deviceId = element.parameterId + node.nodeId;
      element.nodeNo = node.nodeId;
    });
    _listOfSavedNodes.forEach((element) {
      if (element.id == node.id) {
        sameIdCheck = true;
        print('item found is nodeId:  ${element.nodeId} : id: ${element.id}');
      }
    });

    if (!sameIdCheck) {
      if (sameNodeIdCheck(node)) {
        print('same node id : 1');
        return false;
      }
      print('new node');
      _listOfSavedNodes.add(node);
    } else {
      if (sameNodeIdCheck(node)) {
        print('same node id : 2');
        return false;
      }
      print('node exist: updating ...');
      int index = _listOfSavedNodes
          .indexWhere((element) => element.nodeId == node.nodeId);
      _listOfSavedNodes[index] = node;
    }

    /* _listOfSavedNodes.forEach((element) {
      print('---------------------------------------- ');
      print('node.id : ${element.nodeId}');
      print('node.module : ${element.moduleType}');
      print('---------------------------------------- ');
    });
*/
    notifyListeners();
    return true;
  }

  bool sameNodeIdCheck(Node node) {
    bool checkValue = false;
    _listOfSavedNodes.forEach((element) {
      if (element.nodeId == node.nodeId && element.id != node.id) {
        print('same node id found !!!!!');
        checkValue = true;
      }
    });
    if (checkValue) {
      _listOfSavedNodes.removeWhere((element) => element.id == node.id);
    }

    return checkValue;
  }

//------------------------------------------------------- ROOMS *

  Future<Room> fillRoomData(String roomName, {Room editRoom}) async {
    // if(roomName.contains(other))
    String roomId;

    if (editRoom != null) {
      print('fillRoomData: roomid :${editRoom.roomId}');
      roomId = editRoom.roomId;
      _listOfSavedNodes.forEach((element) {
        saveNode(element);
      });
    } else
      roomId = getRoomId(roomName);

    for (int i = 0; i < _listOfSavedNodes.length; i++) {
      for (int j = 0; j < _listOfSavedNodes.length; j++) {
        if (_listOfSavedNodes[i].nodeId == _listOfSavedNodes[j].nodeId &&
            (i != j)) {
          print('------------------------------------- ***');
          print('room may contain same node ids');
          print('------------------------------------- ***');
          return null;
        }
      }
    }

    _listOfSavedNodes.forEach((element) {
      element.listOfDevices.forEach((element) {
        element.deviceRoom = roomName;
      });
    });
    print('------------------------------------- ***');
    print('node no: ${_listOfSavedNodes[0].listOfDevices[0].nodeNo}');
    print('device id: ${_listOfSavedNodes[0].listOfDevices[0].deviceType}');
    print('------------------------------------- ***');
    var myRoom = Room(
      listOfNodes: _listOfSavedNodes,
      roomId: roomId,
      roomName: roomName,
    );
    return myRoom;
  }

  incrementRoomNotifier(Room room) {
    print('increment called  ... ');
    print('incrementNotifier: roomid :${room.roomId}');
    bool contain = false;
    _listOfRooms.forEach((element) {
      if (element.roomId == room.roomId) {
        contain = true;
        return;
      }
    });

    if (contain) {
      int index =
          _listOfRooms.indexWhere((element) => element.roomId == room.roomId);
      _listOfRooms[index] = room;
      print('provider: room EDITED ! ');
    } else {
      print('provider: room ADDED ! ');
      _listOfRooms.add(room);
    }

    notifyListeners();
  }

  Future<bool> deleteRoom(String roomId) async {
    _listOfRooms.removeWhere((element) => element.roomId == roomId);
    notifyListeners();
    return true;
  }

  String getRoomId(String roomName) {
    return roomName + Random().nextInt(20000).toString();
  }
}
