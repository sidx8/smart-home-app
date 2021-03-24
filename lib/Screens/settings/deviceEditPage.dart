import 'package:flutter/material.dart';
import 'package:lumoshomes/models/devices.dart';
import 'package:lumoshomes/models/room.dart';
import 'package:lumoshomes/utils/common/nameChangeDialog.dart';
import '../../utils/moduleBasedDevices.dart';

class DevicesEdit extends StatefulWidget {
  final Room _roomdata;
  DevicesEdit(this._roomdata);

  @override
  _DevicesEditState createState() => _DevicesEditState();
}

class _DevicesEditState extends State<DevicesEdit> {
  List<Device> _listOfDevices;

  addDevicesToList() {
    widget._roomdata.listOfNodes.forEach((node) {
      node.listOfDevices.forEach((device) {
        device.deviceIcon = MyUtils().getIconsByMODULE(node.moduleType);
        _listOfDevices.add(device);
      });
    });
  }

  @override
  void initState() {
    _listOfDevices = [];
    addDevicesToList();
    super.initState();
  }

  // customListTile(IconData iconData, String title, String subtitle,
  //         BuildContext context) =>
  //     ListTile(
  //       leading: Icon(
  //         iconData,
  //         color: Theme.of(context).primaryColor,
  //       ),
  //       title: Text(
  //         title,
  //         style: TextStyle(
  //           height: 2,
  //           fontSize: 18,
  //           fontWeight: FontWeight.w400,
  //         ),
  //       ),
  //       subtitle: Text(subtitle),
  //     );

  // customDivider(BuildContext context) => Divider(
  //       indent: 15,
  //       endIndent: 15,
  //       thickness: 1.5,
  //       color: Theme.of(context).appBarTheme.color,
  //       height: 30,
  //     );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget._roomdata.roomName}',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
        ),
      ),
      body: Container(
          margin: EdgeInsets.all(8),
          child: ListView.builder(
              itemCount: _listOfDevices.length,
              itemBuilder: (context, index) {
                return DeviceNameTile(
                    _listOfDevices[index], widget._roomdata.roomId);
              })),
    );
  }
}

class DeviceNameTile extends StatefulWidget {
  final Device _device;
  final String _roomId;
  DeviceNameTile(
    this._device,
    this._roomId,
  );

  @override
  _DeviceNameTileState createState() => _DeviceNameTileState();
}

class _DeviceNameTileState extends State<DeviceNameTile> {
  TextEditingController _deviceNameController;

  @override
  void initState() {
    super.initState();
    _deviceNameController = TextEditingController();
    print('room name init called ');
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          var newName = await showNameChangeDialog(
              context: context,
              device: widget._device,
              roomId: widget._roomId,
              updateValue: UpdateValue.Device);
          setState(() {
            if (newName != null) widget._device.deviceName = newName;
          });
        },
        child: Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Theme.of(context).buttonColor,
              borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Icon(
                widget._device.deviceIcon,
                color: Theme.of(context).accentColor,
              ),
              SizedBox(width: 12),
              Text(
                widget._device.deviceName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ));
  }
}
