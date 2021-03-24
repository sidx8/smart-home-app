import 'package:lumoshomes/models/account.dart';
import 'package:lumoshomes/models/devices.dart';
import 'package:lumoshomes/models/node.dart';
import 'package:lumoshomes/models/room.dart';
import 'package:lumoshomes/services/initDatabase.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/utils/value_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseRepo {
  DatabaseRepo._();

  factory DatabaseRepo() {
    return DatabaseRepo._();
  }

  final _dataStore = intMapStoreFactory.store('mainStore');
  final _accountStore = intMapStoreFactory.store('accountStore');

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future<bool> addRoomToDatabase(Room room) async {
    var check = await _dataStore.add(await _db, room.toMap());
    // await getAllRooms();
    return check > 0;
  }

  Future<bool> addListOfRoomsToDatabase(List<Room> listOfRooms) async {
    try {
      for (var i = 0; i < listOfRooms.length; i++) {
        await addRoomToDatabase(listOfRooms[i]);
        print('adding rooms');
      }
      print('<LOCALLY SAVED >');
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> deleteRoom(String roomId) async {
    print('delete start for : $roomId');
    Finder finder = Finder(filter: Filter.equals("roomId", roomId));
    var check = await _dataStore.delete(await _db, finder: finder);
    print('check : $check');
    return check > 0;
  }

  Future deleteWholeLocalDatabase() async {
    print('WHOLE DATABASE DELETED !!  ');
    await _dataStore.delete(await _db);
    await _accountStore.delete(await _db);
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  Future<bool> editDevice(String roomId, Device device) async {
    print('delete start for : $roomId');
    Finder finder = Finder(filter: Filter.equals("roomId", roomId));
    var check = await _dataStore.delete(await _db, finder: finder);
    print('check : $check');
    return check > 0;
  }

  Future<List<Room>> getAllRooms() async {
    // await deleteWholeRoomList();
    // return null;

    // print('get room database');
    try {
      var rooms = await _dataStore.find(await _db);

      List<Room> listOfRooms = rooms.map((e) {
        return Room.fromMap(e.value);
      }).toList();
      // print('------------------------------------- ***');
      // print('rooms length is: ${listOfRooms.length}  ');
      // print('------------------------------------- ***');
      return listOfRooms;
    } catch (err) {
      print('error: databaseRepo: $err');
      return null;
    }
  }

  Future<bool> editRoomName({String roomId, String roomName}) async {
    Finder finder = Finder(filter: Filter.equals("roomId", roomId));
    var check = await _dataStore.findFirst(await _db, finder: finder);
    if (check == null) return false;

    Map<String, dynamic> tempCheck = cloneMap(check.value);
    var myRoomValue = Room.fromMap(tempCheck);
    myRoomValue.roomName = roomName;
    myRoomValue.listOfNodes.forEach((nodes) {
      nodes.listOfDevices.forEach((devices) {
        devices.deviceRoom = roomName;
      });
    });
    var updateVal = await _dataStore
        .record(check.key)
        .update(await _db, myRoomValue.toMap());
    if (updateVal != null) {
      print(' successfully updated !');
      return true;
    } else
      return false;
  }

  Future<bool> editDeviceOfRoomName(Device device, String roomId) async {
    Finder finder = Finder(filter: Filter.equals("roomId", roomId));
    var check = await _dataStore.findFirst(await _db, finder: finder);

    if (check == null) return false;
    Map<String, dynamic> tempCheck = cloneMap(check.value);
    var myRoomValue = Room.fromMap(tempCheck);
    List<Node> listOfNodes = myRoomValue.listOfNodes;
    listOfNodes.forEach((node) {
      node.listOfDevices.forEach((d) {
        if (d.deviceId == device.deviceId) {
          d.deviceName = device.deviceName;
          return;
        }
      });
    });
    final myNewRoom = Room(
            listOfNodes: listOfNodes,
            noOfDevices: myRoomValue.noOfDevices,
            roomId: myRoomValue.roomId,
            roomName: myRoomValue.roomName)
        .toMap();
    var updateVal =
        await _dataStore.record(check.key).update(await _db, myNewRoom);
    if (updateVal != null) {
      return true;
    } else
      return false;
  }

  Future<bool> reorderRoomsSave(List<Room> listOfRooms) async {
    try {
      await _dataStore.delete(await _db);
      await addListOfRoomsToDatabase(listOfRooms);
      return true;
    } catch (err) {
      print('error on reordering ');
      return false;
    }
  }

  Future<bool> setAccountData(Account account) async {
    try {
      var check = await _accountStore.add(await _db, account.toMap());
      return check != null;
    } catch (err) {
      print('error in account save: $err');
      return false;
    }
  }

  Future<Account> getAccountData() async {
    try {
      var accountSnap = await _accountStore.findFirst(await _db);
      if (accountSnap != null) {
        return Account.fromMap(accountSnap.value);
      } else
        return null;
    } catch (err) {
      print('error while account fetch : $err');
      return null;
    }
  }

  Future<bool> changeUserName(String userName) async {
    try {
      var accountSnap = await _accountStore.findFirst(await _db);
      if (accountSnap != null) {
        var newAccount = Account.fromMap(accountSnap.value);
        newAccount.userName = userName;
        var count = await _accountStore.update(await _db, newAccount.toMap());
        return count > 0;
      } else
        return null;
    } catch (err) {
      print('error while updating account name');
      return null;
    }
  }
}
