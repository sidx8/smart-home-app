import 'package:flutter/material.dart';
import 'package:lumoshomes/Providers/roomProvider.dart';
import 'package:lumoshomes/models/room.dart';
import 'package:lumoshomes/services/mainRepository.dart';
import 'package:lumoshomes/utils/constants.dart';
import 'package:lumoshomes/widgets/roomsWidget.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatefulWidget {
  final List<Room> mainRoomList;
  final String userId;
  AdminHomePage(this.mainRoomList, this.userId);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  TextEditingController _customerIdController;
  List<Room> _listOfRooms;
  GlobalKey<FormState> _formKey;
  bool _isUploaded = false;

  @override
  void initState() {
    super.initState();
    _customerIdController = TextEditingController();
    _listOfRooms = [];
    _formKey = GlobalKey<FormState>();
    setState(() {
      _customerIdController.text = widget.userId ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    print('widget useris: ${widget.userId}');
    return ChangeNotifierProvider(
        create: (context) => RoomProvider(),
        builder: (context, _) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Provider.of<RoomProvider>(context, listen: false)
                .setListOfRooms(widget.mainRoomList ?? []);
          });
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text('Admin page'),
                  actions: [
                    Container(
                      margin: EdgeInsets.all(8),
                      child: RaisedButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            var check = await showMyDialog();
                            setState(() {
                              if (check != null) _isUploaded = check;
                            });
                          }
                        },
                        icon: Icon(
                          _isUploaded ? Icons.check : Icons.save,
                          color: _isUploaded
                              ? Theme.of(context).accentColor
                              : Colors.white,
                        ),
                        label: Text(_isUploaded ? 'Saved' : 'Save',
                            style: TextStyle(color: Colors.white)),
                      ),
                    )
                  ],
                ),
                body: Container(
                    margin: EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (value) => value.length > 0
                                    ? null
                                    : 'Enter Customer Id',
                                controller: _customerIdController,
                                keyboardType: TextInputType.name,
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 18),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.security,
                                    size: 32,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  hintText: 'Customer Id',
                                  hintStyle: TextStyle(color: Colors.black54),
                                ),
                              ),
                            ),
                          ),
                          Consumer<RoomProvider>(
                            builder: (context, value, _) {
                              _listOfRooms = value.getListOfRooms;
                              return ListView.builder(
                                padding: EdgeInsets.all(16),
                                shrinkWrap: true,
                                itemCount: _listOfRooms.length,
                                itemBuilder: (context, index) =>
                                    RoomWidget(_listOfRooms[index]),
                              );
                            },
                          )
                        ],
                      ),
                    )),
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () async {
                    Room room = await Navigator.of(context)
                        .pushNamed(RouteConstant.addRoomScreen) as Room;
                    if (room != null) {
                      print('incrementNotifier: roomid :${room.roomId}');

                      Provider.of<RoomProvider>(context, listen: false)
                          .incrementRoomNotifier(room);
                    }
                  },
                  label: Text('Add Rooms', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          );
        });
  }

  Future<bool> showMyDialog() async {
    bool _isLoading = false;
    // bool uploadCheck = false;
    bool uploadeCheck = await showDialog(
        useSafeArea: true,
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: StatefulBuilder(
                builder: (_, setState) {
                  return Container(
                    margin: EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Confirm this id',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            _customerIdController.text,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.end,
                          children: [
                            RaisedButton(
                              color: Colors.redAccent,
                              child: Text('cancle'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            RaisedButton(
                              color: Theme.of(context).primaryColor,
                              child: Text('Save'),
                              onPressed: () async {
                                setState(() => _isLoading = true);
                                var check = await MainRepository()
                                    .addListOfRooms(_listOfRooms,
                                        _customerIdController.text);
                                setState(() => _isLoading = false);
                                Navigator.of(context).pop(check);
                              },
                            ),
                            _isLoading
                                ? Padding(
                                    padding: EdgeInsets.all(8),
                                    child: CircularProgressIndicator(),
                                  )
                                : SizedBox(),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ));

    return uploadeCheck;
  }
}
