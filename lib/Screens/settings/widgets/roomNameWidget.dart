import 'package:flutter/material.dart';
import 'package:lumoshomes/models/room.dart';
import 'package:lumoshomes/utils/common/nameChangeDialog.dart';

import '../deviceEditPage.dart';

class RoomNameWidget extends StatefulWidget {
  final Room roomdata;
  RoomNameWidget(this.roomdata);

  @override
  _RoomNameWidgetState createState() => _RoomNameWidgetState();
}

class _RoomNameWidgetState extends State<RoomNameWidget> {
  TextEditingController _roomNameController;

  @override
  void initState() {
    super.initState();
    _roomNameController = TextEditingController();
    print('room name init called ');
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 80, minHeight: 50),
      child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DevicesEdit(widget.roomdata)));
          },
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(maxHeight: 70, minHeight: 50),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: Theme.of(context).buttonColor,
                    borderRadius: BorderRadius.circular(1)),
                padding: EdgeInsets.all(16),
                //  margin: EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(width: 12),
                    Text(widget.roomdata.roomName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        )),
                    Expanded(child: SizedBox()),
                    IconButton(
                      icon: Icon(Icons.edit),
                      color: Theme.of(context).primaryColor,
                      onPressed: () async {
                        var newName = await showNameChangeDialog(
                            context: context,
                            room: widget.roomdata,
                            updateValue: UpdateValue.Room);
                        setState(() {
                          if (newName != null)
                            widget.roomdata.roomName = newName;
                        });
                      },
                    )
                  ],
                ),
              ),
              Container(
                height: 10,
                color: Colors.red,
              ),
            ],
          )),
    );
  }
}
