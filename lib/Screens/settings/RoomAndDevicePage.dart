import 'package:flutter/material.dart';
import 'package:lumoshomes/Screens/settings/widgets/roomNameWidget.dart';
import 'package:lumoshomes/services/databaseRepo.dart';

import '../../models/room.dart';

class RoomSettings extends StatefulWidget {
  @override
  _RoomSettingsState createState() => _RoomSettingsState();
}

class _RoomSettingsState extends State<RoomSettings> {
  Future _getRoomsData;

  @override
  void initState() {
    _getRoomsData = DatabaseRepo().getAllRooms();
    super.initState();
  }

  //List<Room> roomdata;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rooms',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(5),
        child: FutureBuilder(
          future: _getRoomsData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            List<Room> listOfRooms = snapshot.data;
            List<Widget> roomWidgetList = listOfRooms.map((room) {
              return GestureDetector(
                  key: ValueKey(room.roomId), child: RoomNameWidget(room));
            }).toList();
            // return ListView.builder(
            //   itemCount: listOfRooms.length,
            //   itemBuilder: (context, index) {
            //     return GestureDetector(
            //         child: RoomNameWidget(listOfRooms[index]));
            //   },
            // );
            return StatefulBuilder(builder: (context, setState) {
              return Container(
                height: double.maxFinite,
                child: ReorderableListView(
                  padding: EdgeInsets.all(5),
                  onReorder: (oldIndex, newIndex) async {
                    print('oldIndex: $oldIndex');
                    print('newIndex: $newIndex');
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final roomItem = listOfRooms.removeAt(oldIndex);
                    listOfRooms.insert(newIndex, roomItem);
                    var check =
                        await DatabaseRepo().reorderRoomsSave(listOfRooms);
                    setState(() {
                      if (check) {
                        final items = roomWidgetList.removeAt(oldIndex);
                        roomWidgetList.insert(newIndex, items);
                      }
                    });
                  },
                  children: roomWidgetList,
                  //   children: ListView.builder(
                  //   itemCount: listOfRooms.length,
                  //   itemBuilder: (context, index) {
                  //     return GestureDetector(
                  //         child: RoomNameWidget(listOfRooms[index]));
                  //   },
                  // ),
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
