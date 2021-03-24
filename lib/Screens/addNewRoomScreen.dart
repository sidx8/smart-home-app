import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lumoshomes/Providers/roomProvider.dart';
import 'package:lumoshomes/models/node.dart';
import 'package:lumoshomes/models/room.dart';
import 'package:lumoshomes/utils/styleConstant.dart';
import 'package:lumoshomes/widgets/nodeWidget.dart';
import 'package:provider/provider.dart';

class AddNewRoomScreen extends StatefulWidget {
  AddNewRoomScreen();
  @override
  _AddNewRoomScreenState createState() => _AddNewRoomScreenState();
}

class _AddNewRoomScreenState extends State<AddNewRoomScreen> {
  TextEditingController _roomNameController;
  GlobalKey<FormState> _formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;
  // List<Node> _listOfNodes = [];

  List<Node> _listOfNodeWidget = [];

  @override
  void initState() {
    _roomNameController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _scaffoldKey = GlobalKey<ScaffoldState>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Room roomArg = ModalRoute.of(context).settings.arguments as Room;

    _roomNameController.text = roomArg != null ? roomArg.roomName : '';

    return ChangeNotifierProvider.value(
      value: RoomProvider(
          listOfNode: roomArg != null ? roomArg.listOfNodes : null),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: TextFormField(
            validator: (value) => value.isEmpty ? 'Enter room name' : null,
            controller: _roomNameController,
            style: TextStyle(
              color: Colors.black.withOpacity(.7),
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
            decoration: InputDecoration(
                enabledBorder: StyleConstant.outlineInputBorder,
                labelText: 'Enter room name',
                labelStyle: StyleConstant.textStyle),
          ),
        ),
      ),
      builder: (context, child) {
        _listOfNodeWidget = context.watch<RoomProvider>().listOfnodesWidget;
        return WillPopScope(
          onWillPop: () async => Future.value(roomArg != null ? false : true),
          child: SafeArea(
              child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text('Add Room'),
                automaticallyImplyLeading: roomArg != null ? false : true,
              ),
              body: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      child,
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _listOfNodeWidget.length,
                        itemBuilder: (_, index) {
                          var nodeItem = _listOfNodeWidget[index];
                          return NodeWidget(nodeItem,
                              key: ValueKey(nodeItem.id));
                        },
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        onPressed: () {
                          var nodeRandomId =
                              Random().nextInt(100000).toString();
                          print('new node id : $nodeRandomId');
                          Provider.of<RoomProvider>(context, listen: false)
                              .addNewNode(Node(id: nodeRandomId));
                        },
                        child: Text(
                          'Add New Node +',
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
              bottomNavigationBar: Container(
                margin: EdgeInsets.all(8),
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      Room room = await Provider.of<RoomProvider>(context,
                              listen: false)
                          .fillRoomData(_roomNameController.text,
                              editRoom: roomArg);
                      if (room != null) {
                        Navigator.of(context).pop(room);
                      } else {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('Room may contain same node ids'),
                          // backgroundColor: Theme.of(context),
                        ));
                        return;
                      }
                    } else
                      return;
                  },
                  label: Text(
                      'Add Room + ${Provider.of<RoomProvider>(context).getListOfNodes.length} Node',
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          )),
        );
      },
    );
  }
}
