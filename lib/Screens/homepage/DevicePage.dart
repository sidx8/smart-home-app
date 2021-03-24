import 'package:flutter/material.dart';
import 'package:lumoshomes/Providers/deviceProvider.dart';
import 'package:lumoshomes/widgets/deviceWidget.dart';
import 'package:provider/provider.dart';

class DevicePage extends StatefulWidget {
  final int _roomIndex;

  DevicePage(this._roomIndex);

  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Consumer<DeviceProvider>(
              builder: (context, value, _) {
                var myDevices = value.getListOfDevices(widget._roomIndex);
                if (myDevices == null)
                  return Center(child: CircularProgressIndicator());
                else
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (ctx, i) {
                      final device = myDevices[i];
                      var currentState = device.deviceState;
                      // print('current state is : $currentState');
                      return DeviceWidget(device, currentState);
                    },
                    itemCount: myDevices.length,
                  );
              },
            ),
          ],
        ),
      ),
    );
    //   ),
    // );
  }
}
