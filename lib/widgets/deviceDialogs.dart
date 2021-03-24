import 'package:flutter/material.dart';
import 'package:lumoshomes/utils/helpers.dart';
import '../widgets/myColorPicker.dart';

// 270 for music
// 290 for random 2
// 260 for random 1
// 265 for smooth
// 280 for rainbow

class DeviceDialogs {
  static Future<int> rgbDialog(BuildContext context, int initialValue) async {
    // Color currentColor = Color(0xffb114ff);
    int shortInitialValue = initialValue > 0
        ? Helpers.parseColorIntToListOfRgb(initialValue)[0]
        : 0;
    Color pickerColor = shortInitialValue > 0 && shortInitialValue <= 255
        ? Helpers.colorParseIntToColor(initialValue)
        : Color(0xffb114ff);
    print('picker value : $pickerColor');
    print('short initial value : $shortInitialValue');
    print('initial value : $initialValue');

    return await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          void onPanEndDone() {
            print('picked color is: $pickerColor');
            Navigator.of(context)
                .pop(Helpers.colorParseColorToInt(pickerColor));
          }

          void changeColor(Color color) {
            setState(() => pickerColor = color);
            // setState(() => currentColor = pickerColor);
            // Navigator.of(context)
            //     .pop(Helpers.colorParseColorToInt(currentColor));
          }

          return AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  MyCircleColorPicker(
                    initialColor: pickerColor,
                    onChanged: (color) => changeColor(color),
                    size: const Size(240, 240),
                    strokeWidth: 4,
                    onPanEndDone: onPanEndDone,
                    thumbSize: 36,
                  ),
                  Wrap(
                    // alignment: WrapAlignment.spaceAround,
                    runSpacing: 4,
                    spacing: 8,
                    direction: Axis.horizontal,
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RaisedButton(
                        color: shortInitialValue == 265
                            ? Theme.of(context).accentColor
                            : Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.of(context).pop(265265265);
                        },
                        child: Text('Smooth',
                            style: TextStyle(color: Colors.white)),
                      ),
                      RaisedButton(
                        color: shortInitialValue == 280
                            ? Theme.of(context).accentColor
                            : Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.of(context).pop(280280280);
                        },
                        child: Text('Rainbow',
                            style: TextStyle(color: Colors.white)),
                      ),
                      RaisedButton(
                        color: shortInitialValue == 270
                            ? Theme.of(context).accentColor
                            : Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.of(context).pop(270270270);
                        },
                        child: Text('Music',
                            style: TextStyle(color: Colors.white)),
                      ),
                      RaisedButton(
                        color: shortInitialValue == 260
                            ? Theme.of(context).accentColor
                            : Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.of(context).pop(260260260);
                        },
                        child: Text('Random 1',
                            style: TextStyle(color: Colors.white)),
                      ),
                      RaisedButton(
                        color: shortInitialValue == 290
                            ? Theme.of(context).accentColor
                            : Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.of(context).pop(290290290);
                        },
                        child: Text('Random 2',
                            style: TextStyle(color: Colors.white)),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  // static Future<int> rgbDialog(BuildContext context) async {
  //   return await showDialog(
  //       context: context,
  //       builder: (context) => Dialog(
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(12)),
  //             child: StatefulBuilder(
  //               builder: (context, setState) {
  //                 return Container(
  //                   // alignment: Alignment.center,
  //                   child: GridView.builder(
  //                     shrinkWrap: true,
  //                     physics: NeverScrollableScrollPhysics(),
  //                     padding: EdgeInsets.all(8),
  //                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                         crossAxisCount: 4,
  //                         childAspectRatio: 1,
  //                         crossAxisSpacing: 4,
  //                         mainAxisSpacing: 4),
  //                     itemBuilder: (context, index) {
  //                       final reindex = (index + 2) * 5;
  //                       return GestureDetector(
  //                           onTap: () {
  //                             print('tap : $reindex');
  //                             Navigator.pop(context, reindex);
  //                           },
  //                           child: Helpers.getGridItemOfRGB(reindex));
  //                     },
  //                     itemCount: 24,
  //                   ),
  //                 );
  //               },
  //             ),
  //           ));
  // }

  static Future<int> fanDialog(
      BuildContext context, double initialValue) async {
    double _sliderValue = initialValue;
    return await showDialog(
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("fan speed",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Container(
                        height: 80,
                        child: Slider(
                          label: '$_sliderValue',
                          value: _sliderValue,
                          divisions: 10,
                          onChangeEnd: (value) {
                            Navigator.pop(context, value.floor());
                          },
                          min: 0,
                          max: 10,
                          onChanged: (value) =>
                              setState(() => _sliderValue = value),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ));
  }

  static Future<int> curtainDialog(
      BuildContext context, double initialValue) async {
    double _sliderValue = initialValue <= 100 ? initialValue : 0;

    return await showDialog(
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: StatefulBuilder(
                builder: (context, setState) {
                  print('sliderValue is : $_sliderValue ');
                  String _sliderLable = _sliderValue == 0
                      ? 'Close'
                      : (_sliderValue == 100
                          ? 'Open 100%'
                          : _sliderValue.floor().toString() + '%');
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("Curtains",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Container(
                        height: 80,
                        child: Slider(
                          label: _sliderLable,
                          value: _sliderValue.toDouble(),
                          divisions: 3,
                          onChangeEnd: (value) {
                            Navigator.pop(context, value.floor());
                          },
                          min: 0,
                          max: 100,
                          onChanged: (value) =>
                              setState(() => _sliderValue = value),
                        ),
                      ),
                      FlatButton(
                        child: Text(
                          'Auto',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: initialValue == 110
                            ? Theme.of(context).accentColor
                            : Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.of(context).pop(110);
                        },
                      )
                    ],
                  );
                },
              ),
            ));
  }
}
