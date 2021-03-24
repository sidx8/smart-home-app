import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import 'package:lumoshomes/models/account.dart';
import 'package:lumoshomes/models/room.dart';

class MainRepository {
  MainRepository._();
  factory MainRepository() {
    return MainRepository._();
  }
  static const DEVICE_STATE = 'deviceState';
  DatabaseReference _databaseRef = FirebaseDatabase().reference();

  final logger = Logger(
      printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 70,
    colors: true,
    printEmojis: true,
    printTime: false,
  ));

  Future<bool> addNewRoom(Room room, String userId) async {
    try {
      await _databaseRef.child('root/$userId/room').set(room.toMap());
      return true;
    } catch (err) {
      logger.e('MAIN_REPO: <add new room>: $err');

      return false;
    }
  }

  Future<bool> addListOfRooms(List<Room> room, String userId) async {
    List<Map<String, dynamic>> mapOfListOfRooms =
        room.map((e) => e.toMap()).toList();
    try {
      print('adding to realtime database: start ');

      await _databaseRef.child('root/$userId/rooms/').set(mapOfListOfRooms);
      return true;
    } catch (err) {
      logger.e('MAIN_REPO: <add list of rooms>: $err');

      return false;
    }
  }

  Future<Map<String, String>> getAdminIdAndPassword() async {
    try {
      var dataRef = await _databaseRef.child('security').once();
      return Map<String, String>.from(dataRef.value);
    } catch (err) {
      print(': $err');
      logger.e('MAIN_REPO: <error while getting admin auth>: $err');

      return null;
    }
  }

  Future<bool> setUIDtoUserid(String userId, String uid) async {
    try {
      await _databaseRef.child('root/$userId/uid').set(uid);
      print('database updated');
      return true;
    } catch (err) {
      logger.e('MAIN_REPO: <error while setting uid>: $err');

      return false;
    }
  }

  Future<Account> getAccountData(String userId) async {
    try {
      var dataRef = await _databaseRef.child('root/$userId/account').once();
      var accountDataMap = dataRef.value as Map;
      var accountData = Map<String, dynamic>.from(accountDataMap);

      // Map<String, dynamic>.from(dataRef.value);
      print('account data : $accountData');
      return Account.fromMap(accountData);
    } catch (err) {
      logger.e('MAIN_REPO: <error while getting account>: $err');

      return null;
    }
  }

  Future<bool> addAccountDataToDatabase(Account account) async {
    try {
      await _databaseRef
          .child('root/${account.userId}/account')
          .set(account.toMap());
      print('database updated');
      return true;
    } catch (err) {
      logger.e('MAIN_REPO: <error while setting uid>: $err');

      return false;
    }
  }

  Future<List<Room>> getLisOfRoomsByCustomerId(String customerId) async {
    try {
      var dataRef = await _databaseRef.child('root/$customerId/rooms').once();

      if (dataRef.value != null) {
        var myRooms = dataRef.value as List;
        // print('my room data: $myRooms');
        List<Room> myListOfRooms = myRooms
            .map((e) => e as Map)
            .map((e) => Map<String, dynamic>.from(e))
            .map((e) => Room.fromMap(e))
            .toList();
        return myListOfRooms;
      } else {
        logger.w('MAIN_REPO: no user found with id: $customerId');
        return null;
      }
    } catch (err) {
      logger.e('MAIN_REPO:<error while list by Custoemr ID>: $err');
      return null;
    }
  }

  Future<Map<Account, List<Room>>> getListOfRoomsByUID(String uid) async {
    try {
      var dataRef = await _databaseRef
          .child('root')
          .orderByChild('uid')
          .equalTo(uid)
          .once();

      if (dataRef.value != null) {
        var myRooms = Map<String, dynamic>.from(dataRef.value as Map);
        var myRoomsList = myRooms.values.toList()[0]['rooms'] as List;
        var accountData = myRooms.values.toList()[0]['account'] as Map;
        // print('my room data: $myRoomsList');
        List<Room> myListOfRooms = myRoomsList
            .map((e) => e as Map)
            .map((e) => Map<String, dynamic>.from(e))
            .map((e) => Room.fromMap(e))
            .toList();

        Account myAccount =
            Account.fromMap(Map<String, dynamic>.from(accountData));

        return {myAccount: myListOfRooms};
      } else {
        logger.w('MAIN_REPO: no user found with uid: $uid');
        return null;
      }
    } catch (err) {
      logger.e('MAIN_REPO:<fetching rooms by UID>: $err');

      return null;
    }
  }

  //-------------------------------------------------------------------------
  //---------------------------- save device state --------------------------
  //-------------------------------------------------------------------------

  Future<bool> updateDeviceStateToRealtime(
      String userId, String deviceid, int deviceStateValue) async {
    try {
      await _databaseRef
          .child('$DEVICE_STATE/$userId/$deviceid')
          .set(deviceStateValue);
      logger.i('state updated to realtime');
      return true;
    } catch (err) {
      logger.e('MAIN_REPO:<change device state>: $err');
      return false;
    }
  }

  Future<Map<String, int>> getAllDevicesStates(String userId) async {
    try {
      var dataSnap = await _databaseRef.child('$DEVICE_STATE/$userId').once();
      if (dataSnap == null) {
        logger.w('snapshot data is null');
        throw 'data snapshot is null ';
      }

      var dataRef = dataSnap.value as Map;
      var devicesMapValue = Map<String, int>.from(dataRef);
      return devicesMapValue;
    } catch (err) {
      logger.e('MAIN_REPO:<getting devices state>: $err');
      return null;
    }
  }
}
