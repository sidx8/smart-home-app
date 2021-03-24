import 'package:flutter/material.dart';
import 'package:lumoshomes/Providers/roomProvider.dart';
import 'package:lumoshomes/models/devices.dart';
import 'package:lumoshomes/models/node.dart';
import 'package:lumoshomes/utils/moduleBasedDevices.dart';
import 'package:provider/provider.dart';

class NodeWidget extends StatefulWidget {
  // final Function addNodeToRoom;
  final Node node;
  final Key key;
  NodeWidget(this.node, {this.key}) : super(key: key);
  @override
  _NodeWidgetState createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<NodeWidget> {
  int _currentSelectedValue;
  List<Device> _listOfDevices = [];
  Node myNodeData;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _saved = false;

  OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.black),
      borderRadius: BorderRadius.circular(12),
      gapPadding: 4);

  TextStyle _textStyle = TextStyle(
    color: Colors.black.withOpacity(.7),
    fontWeight: FontWeight.w500,
    fontSize: 20,
  );

  List<DropdownMenuItem> _dropDownMenueItems = [
    DropdownMenuItem(child: Text('Light Module (1)'), value: 0),
    DropdownMenuItem(child: Text('Light Module (2)'), value: 1),
    DropdownMenuItem(child: Text('Light Module (3)'), value: 2),
    DropdownMenuItem(child: Text('Light Module (4)'), value: 3),
    DropdownMenuItem(child: Text('AC Module '), value: 4),
    DropdownMenuItem(child: Text('Fan Module (1)'), value: 5),
    DropdownMenuItem(child: Text('Fan Module (2)'), value: 6),
    DropdownMenuItem(child: Text('RGB Module (1)'), value: 7),
    DropdownMenuItem(child: Text('RGB Module (2)'), value: 8),
    DropdownMenuItem(child: Text('Curtains modules'), value: 9),
  ];

  @override
  void initState() {
    super.initState();

    myNodeData = widget.node;
    _currentSelectedValue = myNodeData.moduleType ?? null;
    _saved = myNodeData?.nodeId != null ? true : false;

    if (_currentSelectedValue != null) {
      _listOfDevices = MyUtils().moduleType(_currentSelectedValue);
      myNodeData.listOfDevices = _listOfDevices;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: _saved ? Colors.white : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color:
                      _saved ? Theme.of(context).accentColor : Colors.grey[400],
                  width: 3)),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (value) => setState(() {
                      myNodeData.nodeId = value;
                      _saved = false;
                    }),
                    initialValue: myNodeData.nodeId ?? '',
                    validator: (value) =>
                        (value.length > 0 && int.parse(value) <= 255)
                            ? null
                            : "enter valid node id",
                    style: TextStyle(
                      color: Colors.black.withOpacity(.7),
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        enabledBorder: _outlineInputBorder,
                        labelText: 'Node Id',
                        labelStyle: _textStyle),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField(
                    validator: (value) =>
                        value != null ? null : 'Choose Module Type',
                    isExpanded: true,
                    value: _currentSelectedValue,
                    items: _dropDownMenueItems,
                    hint: Text('choose module type'),
                    onChanged: (value) {
                      setState(() {
                        _currentSelectedValue = value;
                        _saved = false;
                      });
                      print('value is : $_currentSelectedValue');
                      myNodeData.moduleType = value;
                      _listOfDevices =
                          MyUtils().moduleType(_currentSelectedValue);
                      myNodeData.listOfDevices = _listOfDevices;
                    },
                  ),
                ),
                _currentSelectedValue != null
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: _listOfDevices.length,
                        itemBuilder: (context, index) {
                          Device myDevice = _listOfDevices[index];
                          return DeviceItemList(myDevice: myDevice);
                        },
                      )
                    : SizedBox(),
                RaisedButton(
                  color: _saved
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColor,
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      var check =
                          Provider.of<RoomProvider>(context, listen: false)
                              .saveNode(myNodeData);
                      print('state in nodeWidget : $check');
                      if (check) {
                        setState(() {
                          _saved = true;
                        });
                        print('done');
                      } else {
                        setState(() {
                          _saved = false;
                        });
                      }
                    }
                  },
                  child: Text(
                    _saved ? 'Saved' : 'Save Node',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          child: IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              Provider.of<RoomProvider>(context, listen: false)
                  .removeNode(myNodeData);
            },
            color: Colors.red,
          ),
          right: -8,
          top: -8,
        ),
      ],
    );
  }
}

class DeviceItemList extends StatelessWidget {
  const DeviceItemList({
    Key key,
    @required this.myDevice,
  }) : super(key: key);

  final Device myDevice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.blue[50], borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            myDevice.deviceIcon,
            size: 28,
            color: Colors.blue,
          ),
          SizedBox(width: 12),
          Expanded(
              child: Text(
            myDevice.deviceName,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
        ],
      ),
    );
  }
}
