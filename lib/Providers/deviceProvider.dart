import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:lumoshomes/models/devices.dart';
import 'package:http/http.dart' as http;
import 'package:lumoshomes/models/room.dart';
import 'package:lumoshomes/services/CloudMqttService.dart';
import 'package:lumoshomes/services/mainRepository.dart';
import 'package:lumoshomes/utils/constants.dart';
import 'package:lumoshomes/utils/globalVar.dart';
import 'package:lumoshomes/utils/helpers.dart';
import 'package:lumoshomes/utils/moduleBasedDevices.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart' as Mqtt;

class DeviceProvider extends ChangeNotifier {
  List<Device> _listOfDevice;
  // bool _isTimerIsActive;
  MqttServerClient _client;
  bool _loading = false;
  CloudMqttService cloudMqttService;
  Map<int, List<Device>> _deviceByIndexing;
  MainRepository _mainRepository;
  Map<String, int> currentSyncState;
  MyUtils myUtil;
  bool _isSyncingIsActive = false;

  String _isHeavyLoading;
  final logger = Logger(
      printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 70,
    colors: true,
    printEmojis: true,
    printTime: false,
  ));
  DeviceProvider() {
    _listOfDevice = [];
    cloudMqttService = CloudMqttService(_onMessage, _onDisconnect);
    _deviceByIndexing = {};
    _mainRepository = MainRepository();
    print('device profider called ');
    myUtil = MyUtils();
  }

  bool _isOnWIFI = true;
  String key = 'thisIsMyUserId';
  Timer _currentTimer;
  String _ipAddressInit = '192.168.43';
  bool _isForceOffline;
  // String _ipAddressInit = '192.168.101';

  /// value is deviced
  bool get isInLocalNetwork => _isOnWIFI;

  /// is loading or not
  bool get isLoading => _loading;

  /// this is Heavy loading statement
  String get isHeavyLoading => _isHeavyLoading;

  List<Device> getListOfDevices(int roomAtIndex) {
    return _deviceByIndexing[roomAtIndex];
  }

  initializeRoomsToProvider(
      List<Room> listOfRooms, String routerValue, bool isForceOffline) {
    addDeviceByIndexing(listOfRooms);
    _isForceOffline = isForceOffline;
    _ipAddressInit = '192.168.' + routerValue;
    print('ip address : $_ipAddressInit');
    print('total devices are : ${_totalDevicesLength()}');

    if (_isForceOffline) {
      _isOnWIFI = true;
    }

    //--- --- --- --- --- --- --- --- --- --- --- --- --
    syncDeviceToLocalState2();
    //--- --- --- --- --- --- --- --- --- --- --- --- --
  }

  addDeviceByIndexing(List<Room> listOfRooms) {
    _listOfDevice.clear();
    for (int i = 0; i < listOfRooms.length; i++) {
      _deviceByIndexing[i] = getListOfDevice(listOfRooms[i]);
    }
    _deviceByIndexing.forEach((key, value) {
      _listOfDevice.addAll(value);
    });
    notifyListeners();
  }

  List<Device> getListOfDevice(Room room) {
    List<Device> devicesList = [];
    room.listOfNodes.forEach((node) {
      node.listOfDevices.forEach((device) {
        device.deviceIcon = myUtil.getIconsByMODULE(node.moduleType);
        device.iconAsset = myUtil.getAssetsByMODULE(node.moduleType);
        devicesList.add(device);
      });
    });
    return devicesList;
  }

  changeDeviceState(Device device, int state) async {
    if (_isOnWIFI) {
      indoorControls(state, device);
    } else {
      if (_isForceOffline)
        indoorControls(state, device);
      else
        outdoorControls(state, device);
    }
  }

//--- -- --- - --- - --- - --- - --- - --- - --- - --- - --- - --- ---  INDOOR CONTROLS
  indoorControls(int state, Device device) async {
    String url;
    String modifiedState = deviceStateModifier(device, state);

    try {
      url = // 'http://$_ipAddressInit.184/update?relay=relay1&state=$modifiedState';
          'http://$_ipAddressInit.${device.nodeNo}/update?relay=${device.parameterId}&state=$modifiedState';
      print('--- -- --- - --- - --- - --- - --- - --- - --- - --- - *');
      print('url is : $url');
      print('--- -- --- - --- - --- - --- - --- - --- - --- - --- - *');
      var response = await http.get(url).timeout(Duration(seconds: 2));
      // if (device.deviceType == DeviceType.RGB_TYPE) {
      //   url =  'http://$_ipAddressInit.184/update?relay=relay1&state=$modifiedState';
      //       'http://$_ipAddressInit.${device.nodeNo}/update?relay=${device.parameterId}&state=0';
      //   await http.get(url).timeout(Duration(seconds: 2));
      // }
      print('body : ${response.body}');
      if (response.body != "OK") {
        throw "Required body content not fount";
      }

      // http://192.168.1.110/update?relay=relay1&state=1
      alterDeviceStateFromResponse(device.deviceId, state);
    } catch (err) {
      // setting online true *
      print('TIMEOUT EXCEPTION !!!: $err ');

      // return;

      //--- --- --- --- --- --- --- --- --- --- - COMMENT FOR DEBUGING ONLY
      if (!_isForceOffline) outdoorControls(state, device);
      //--- --- --- --- --- --- --- --- --- --- -

    }
  }

//--- -- --- - --- - --- - --- - --- - --- - --- - --- - --- - --- - --- - ---  OUTDOORS CONTROLS
  outdoorControls(int state, Device device) async {
    String myState = deviceStateModifier(device, state);

    await connectToMQTT();
    try {
      if (_client != null &&
          _client.connectionStatus.state ==
              Mqtt.MqttConnectionState.connected) {
        String encodedPayload = jsonEncode({
          "nodeId": device.nodeNo,
          "relay": device.parameterId,
          "state": myState
        });
        print('mqtt message: $encodedPayload');
        var isPublished = await cloudMqttService.publishMessage(
            encodedPayload, device.parameterId, _client);
        if (isPublished) {
          _loading = false;
          alterDeviceStateFromResponse(device.deviceId, state);
        } else
          throw 'message not published';
      } else
        throw 'client not found';
    } catch (err) {
      if (err.toString().contains('ConnectionException')) {
        print(' BROKER IS NOT CONNECTED : $err');
      } else
        logger.e('error: final $err');
    }
    //check ofline status
    try {
      indoorStatusCheck(device, state);
    } catch (err) {
      logger.e("error is: $err");
    }
  }

//========================================================================== INDOOR STATUS CHECK

  indoorStatusCheck(Device device, int state, {String message}) async {
    print('indoor status check start --- -- --- - --- ---  ***');
    var url =
        'http://$_ipAddressInit.${device.nodeNo}/${device.parameterId}/state';
    print('url check is: $url');
    try {
      var response = await http.get(url).timeout(Duration(seconds: 2));
      if (response.statusCode == 200) {
        logger.i('device found LOCAL: ${response.body} ');

        //--- --- --- --- --- --- --- --- --- --- --- -
        syncDeviceToLocalState2();
        //--- --- --- --- --- --- --- --- --- --- --- -

        disconnectMqtt();
        indoorControls(state, device);
      }
    } catch (err) {
      if (err.toString().contains('TIMEOUT'))
        logger.w('TIMEOUT EXCEPTION ! : INDOOR CHECK !');
      else
        print('err: $err');

      if (_isForceOffline) {
        syncDeviceToLocalState2();
      }
    }
  }
//========================================================================== END

  syncDeviceToLocalState2() async {
    logger.i('local sync start');
    if (_isSyncingIsActive) {
      logger.i('sync is still active');
      return;
    } else {
      _loading = true;
      _isSyncingIsActive = true;
      notifyListeners();
    }

    int failCount = 0;

    if (_isOnWIFI) {
      print('on wifi');
      if (!_loading) {
        _loading = true;
        notifyListeners();
      }
      // _loading = true;

      var totalDevicesByThird = _totalDevicesLength() ~/ 3;
      do {
        for (int i = 0; i < _deviceByIndexing.length; i++) {
          final myDevices = _deviceByIndexing[i];
          for (var device in myDevices) {
            try {
              final url =
                  'http://$_ipAddressInit.${device.nodeNo}/${device.parameterId}/state';
              var response =
                  await http.get(url).timeout(Duration(milliseconds: 800));
              if (response.statusCode == 200) {
                if (!_isOnWIFI) {
                  _isOnWIFI = true;
                }

                var modifiedState =
                    reverseDeviceStateModifier(device, response.body);
                alterDeviceStateFromResponse(device.deviceId, modifiedState);
                print('response is: < ${device.nodeNo} > ${response.body}');
              }
            } catch (err) {
              if (failCount > totalDevicesByThird) {
                //--- --- --- --- --- --- --- --- --- --- --- ---
                if (!_isForceOffline) {
                  await connectToMQTT();
                  await syncAllDevicesWithRealtime();
                }
                //--- --- --- --- --- --- --- --- --- --- --- ---
                _loading = false;
                notifyListeners();
                print('--- -- breaking off --- --- --- -- ');
                break;
              } else {
                if (!_isForceOffline) {
                  failCount++;
                } else {
                  if (_loading) {
                    _loading = false;
                    notifyListeners();
                  }
                }
              }
              logger.e(
                  'failcount : $failCount and count is : $totalDevicesByThird');
            }
          }
        }
      } while (failCount < totalDevicesByThird);
      logger.i(
          'local syncing end , force offline : ${_isForceOffline ? "Active" : "Off"}');
    } else {
      await syncAllDevicesWithRealtime();
      logger.i('realtime sync END! ');
    }
    notifyListeners();
  }

  connectToMQTT() async {
    if (_client != null) {
      if (_client.connectionStatus.state ==
          Mqtt.MqttConnectionState.connected) {
        if (_isOnWIFI) {
          _isOnWIFI = false;
          notifyListeners();
        }
        print('mqtt is already connected');
        return;
      } else
        print('mqtt is not connected');
    }
    logger.v(' connecting to mqtt ... : d ');

    _loading = true;
    notifyListeners();
    while (_client == null ||
        _client.connectionStatus.state != Mqtt.MqttConnectionState.connected) {
      _client = await cloudMqttService.connectToMqttBroker();
      if (_client == null) Future.delayed(Duration(seconds: 1000));
    }

    _isOnWIFI = false;
    _loading = false;
    notifyListeners();
    logger.i('MQTT IS CONNECTED !!');
  }

  disconnectMqtt() {
    if (_client != null &&
        _client.connectionStatus.state == Mqtt.MqttConnectionState.connected) {
      _client?.disconnect();
    }
  }

  alterDeviceStateFromResponse(String deviceId, int newState) {
    try {
      if (_listOfDevice.length > 0) {
        var deviceValue =
            _listOfDevice.firstWhere((element) => element.deviceId == deviceId);
        // print('device id is: ${deviceValue.deviceId}');
        print(
            '--- -- --- - ---  new state : $newState old state: ${deviceValue.currentValue} --- --- -');
        if (deviceValue.currentValue != newState) {
          deviceValue
            ..deviceState = (newState == 0 ? false : true)
            ..currentValue = newState;
          //--- --- --- --- --- --- --- --- --- --- --- --- -- uncomment before final testing

          _mainRepository.updateDeviceStateToRealtime(
              globalUserId, deviceId, newState);

          //--- --- --- --- --- --- --- --- --- --- --- --- --

          if (currentSyncState != null) currentSyncState[deviceId] = newState;

          notifyListeners();
        } else {
          print('--- -- --- - ---  state is same --- --- -');
          print(
              '--- -- --- - ---  new state : $newState old state: ${deviceValue.currentValue} --- --- -');
          print('--- -- --- - ---  state is same --- --- -');
        }
      }
    } catch (err) {
      logger.e('device provider: alter state : $err');
    }
  }

  void _onMessage(List<Mqtt.MqttReceivedMessage> event) {
    print(event.length);
    final Mqtt.MqttPublishMessage recMess =
        event[0].payload as Mqtt.MqttPublishMessage;
    final String message =
        Mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    final jsonMessage = jsonDecode(message);
    final nodeId = jsonMessage['nodeId'];
    final relay = jsonMessage['relay'];
    final String state = jsonMessage['state'];
    logger.i('nodeId: $nodeId  relay: $relay  state: $state');
  }

  _onDisconnect() {
    logger.w('mqtt client is DISCONNECTED');
    _isOnWIFI = true;
    //  notifyListeners();
  }

  syncAllDevicesWithRealtime() async {
    _isHeavyLoading = 'Syncing device state .. ';
    _isSyncingIsActive = false;
    notifyListeners();

    if (currentSyncState == null) {
      logger.i('current state is:  null ! ');
      currentSyncState =
          await _mainRepository.getAllDevicesStates(globalUserId);
      if (currentSyncState == null) {
        _isHeavyLoading = null;
        notifyListeners();
        return;
      }
    } else
      logger.i('current state is not null');

    currentSyncState.entries.forEach((device) {
      var myDevice = _listOfDevice.firstWhere(
          (element) => element.deviceId == device.key,
          orElse: () => null);
      if (myDevice != null) {
        myDevice.currentValue = device.value;
        myDevice.deviceState = device.value == 0 ? false : true;
      }
      // print('device id: ${myDevice?.deviceName} : ${myDevice?.currentValue}');
    });
    _isHeavyLoading = null;
    _loading = false;
    notifyListeners();
  }

  //--- -- --- - --- - --- - --- - --- - --- - --- - --- - --- - --- - ---   SHUT DOWN ALL DEVICES

  shutDownAllDevices() async {
    _isHeavyLoading = 'Shuting down devices .. ';
    notifyListeners();

    for (var device in _listOfDevice) {
      if (device.deviceState) {
        device.deviceState = false;
        final url = // 'http://$_ipAddressInit.184/update?relay=relay1&state=$myState';
            'http://$_ipAddressInit.${device.nodeNo}/update?relay=${device.parameterId}&state=${device.deviceState}';
        try {
          await http.get(url).timeout(Duration(milliseconds: 800));
          alterDeviceStateFromResponse(device.deviceId, 0);
        } catch (err) {
          if (err.toString().contains('TimeoutException')) {
            await connectToMQTT();
            String encodedPayload = jsonEncode({
              "nodeId": device.nodeNo,
              "relay": device.parameterId,
              "state": device.currentValue
            });
            print('mqtt message: $encodedPayload');
            var checkPublish = await cloudMqttService.publishMessage(
                encodedPayload, device.parameterId, _client);
            if (checkPublish) {
              alterDeviceStateFromResponse(device.deviceId, 0);
            }
          }
        }
      }
    }
    _isHeavyLoading = null;
    notifyListeners();
  }

  String deviceStateModifier(Device device, int state) {
    if (device.deviceType == DeviceType.FAN_TYPE)
      return (state * 255 / 10).floor().toString();
    else if (device.deviceType == DeviceType.RGB_TYPE) {
      if (state == 0) {
        return "0";
      }
      List<int> listOfRGB = Helpers.parseColorIntToListOfRgb(state);
      return "R${listOfRGB[0]}G${listOfRGB[1]}B${listOfRGB[2]}";
    } else
      return state.toString();
  }

  int reverseDeviceStateModifier(Device device, String state) {
    //  R25G20B68    real: 255020068

    if (device.deviceType == DeviceType.FAN_TYPE) {
      int newState = int.parse(state);
      return ((newState / 255) * 10).floor();
    } else if (device.deviceType == DeviceType.RGB_TYPE) {
      if (state == "0" || state == "R0B0G0") {
        print('------------------------------------- ***');
        print('state is: 0 here');
        print('------------------------------------- ***');
        return 0;
      }
      int orderedInt = Helpers.parseUnorderedStringToOrderedInt(state);
      print('return data: $orderedInt');
      return orderedInt;
    } else
      return int.parse(state);
  }

  int _totalDevicesLength() {
    var count = 0;
    _deviceByIndexing.forEach((key, value) {
      count += value.length;
    });
    return count;
  }
}
