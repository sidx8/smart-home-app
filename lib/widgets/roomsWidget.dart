import 'package:flutter/material.dart';
import 'package:lumoshomes/Providers/roomProvider.dart';
import 'package:lumoshomes/models/room.dart';
import 'package:lumoshomes/utils/constants.dart';
import 'package:provider/provider.dart';

class RoomWidget extends StatefulWidget {
  final Room room;
  const RoomWidget(this.room);

  @override
  _RoomWidgetState createState() => _RoomWidgetState();
}

class _RoomWidgetState extends State<RoomWidget> {
  int noOfDevices() {
    var count = 0;
    widget.room.listOfNodes.forEach((element) {
      element.listOfDevices.forEach((element) {
        count++;
      });
    });
    return count;
  }

  dialogPopup(BuildContext myContext) {
    showDialog(
        context: myContext,
        builder: (context) {
          return AlertDialog(
            title: Text('Are you sure? you want to delete this room !'),
            actions: [
              RaisedButton(
                child: Text('Delete', style: TextStyle(color: Colors.white)),
                color: Colors.redAccent,
                onPressed: () {
                  Provider.of<RoomProvider>(myContext, listen: false)
                      .deleteRoom(widget.room.roomId);
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                color: Colors.white,
                child: Text('cancle'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print('tap');
        Provider.of<RoomProvider>(context, listen: false)
            .setASpecificRoom(widget.room);
        Room room = await Navigator.of(context)
                .pushNamed(RouteConstant.addRoomScreen, arguments: widget.room)
            as Room;
        if (room != null) {
          Provider.of<RoomProvider>(context, listen: false)
              .incrementRoomNotifier(room);
        }
      },
      onDoubleTap: () {
        print('double tap');
        dialogPopup(context);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.blue[50], borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Expanded(
                child:
                    Text(widget.room.roomName, style: TextStyle(fontSize: 18))),
            Text(
              noOfDevices().toString(),
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
