import 'package:flutter/material.dart';
import 'package:lumoshomes/models/devices.dart';
import 'package:lumoshomes/models/room.dart';
import 'package:lumoshomes/services/databaseRepo.dart';

import '../styleConstant.dart';

enum UpdateValue { Room, Device }

Future<String> showNameChangeDialog({
  BuildContext context,
  Device device,
  Room room,
  String roomId,
  UpdateValue updateValue,
}) async {
  bool _isError = false;
  var deviceController = TextEditingController();
  bool _isRoomToUpdate = updateValue == UpdateValue.Room;

  return await showDialog(
    context: context,
    builder: (context) {
      if (_isRoomToUpdate)
        deviceController.text = room.roomName;
      else
        deviceController.text = device.deviceName;
      return Dialog(
        child: StatefulBuilder(builder: (context, setState) {
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      child: Text(
                        _isRoomToUpdate ? 'Edit Room Name' : 'Edit Device name',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                  TextField(
                    controller: deviceController,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        enabledBorder: StyleConstant.outlineInputBorder,
                        labelText: _isRoomToUpdate
                            ? 'Edit Room Name'
                            : 'Edit Device name',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.black.withOpacity(.7),
                        )),
                  ),
                  SizedBox(height: 16),
                  RaisedButton(
                    onPressed: () async {
                      if (deviceController.text != null &&
                          deviceController.text.isNotEmpty) {
                        bool check;
                        if (_isRoomToUpdate) {
                          print('room name update');

                          check = await DatabaseRepo().editRoomName(
                              roomName: deviceController.text,
                              roomId: room.roomId);
                        } else {
                          print('device name update');
                          device.deviceName = deviceController.text;
                          check = await DatabaseRepo()
                              .editDeviceOfRoomName(device, roomId);
                        }
                        if (check) {
                          Navigator.pop(context, deviceController.text);
                        } else {
                          setState(() {
                            _isError = true;
                          });
                        }
                        print('successfully updated !!');
                      } else {
                        print('value is empty or null');
                        setState(() {
                          _isError = true;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Text('Save',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                  _isError
                      ? Padding(
                          padding: EdgeInsets.all(8),
                          child: Center(
                              child: Text('error while updating name !!',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                  ))))
                      : SizedBox(),
                ],
              ));
        }),
      );
    },
  );
}
