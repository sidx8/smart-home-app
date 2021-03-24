import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lumoshomes/Providers/deviceProvider.dart';
import 'package:lumoshomes/models/devices.dart';
import 'package:lumoshomes/utils/constants.dart';
import 'package:lumoshomes/widgets/deviceDialogs.dart';
import 'package:provider/provider.dart';

class DeviceWidget extends StatefulWidget {
  final Device _device;
  final bool _currentState;
  DeviceWidget(this._device, this._currentState);

  @override
  _DeviceWidgetState createState() => _DeviceWidgetState();
}

class _DeviceWidgetState extends State<DeviceWidget>
    with SingleTickerProviderStateMixin {
  bool _isSwitchOn = false;
  int _dialogValue = 0;
  Device _myDevice;
  Animation _animation;
  AnimationController _animationController;

  int getDeviceValue(DeviceType deviceType, bool isOn) {
    switch (deviceType) {
      case DeviceType.ON_OFF_TYPE:
        return isOn ? 1 : 0;
        break;
      case DeviceType.FAN_TYPE:
        return isOn ? 5 : 0;
        break;
      case DeviceType.RGB_TYPE:
        return isOn ? 255020068 : 0;
        break;
      case DeviceType.CURTAIN_TYPE:
        return isOn ? 100 : 0;
        break;
      default:
        return isOn ? 1 : 0;
    }
  }

  Duration fanDurationWithSpeed(int value) {
    if (value >= 8)
      return Duration(seconds: 1);
    else if (value >= 5)
      return Duration(seconds: 2);
    else if (value >= 3)
      return Duration(seconds: 3);
    else
      return Duration(seconds: 5);
  }

  Future<int> onLongPressDialogType(DeviceType deviceType, int initialValue) {
    switch (deviceType) {
      case DeviceType.FAN_TYPE:
        return DeviceDialogs.fanDialog(context, initialValue.toDouble());
        break;
      case DeviceType.ON_OFF_TYPE:
        return Future.value(null);
        break;
      case DeviceType.RGB_TYPE:
        return DeviceDialogs.rgbDialog(context, initialValue);
        break;
      case DeviceType.CURTAIN_TYPE:
        return DeviceDialogs.curtainDialog(context, initialValue.toDouble());
      default:
        return Future.value(null);
    }
  }

  animationView() {
    if (widget._currentState && _myDevice.deviceType == DeviceType.FAN_TYPE) {
      if (_myDevice.currentValue != null) {
        _animationController.duration =
            fanDurationWithSpeed(_myDevice.currentValue);
      } else {
        print(' ----------- current value is still null  ------------ ');
      }
      _animationController.repeat();
    } else {
      _animationController.stop();
    }
  }

  @override
  void initState() {
    _myDevice = widget._device;

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5))
          ..repeat();
    _animation =
        CurvedAnimation(curve: Curves.linear, parent: _animationController);
    animationView();
    // print(
    //     'deviceName: ${_myDevice.deviceName} : type: ${_myDevice.nodeNO}');
    super.initState();
  }

  @override
  void didUpdateWidget(DeviceWidget oldWidget) {
    animationView();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isSwitchOn = widget._currentState;

    return GestureDetector(
      onTap: () {
        _isSwitchOn = !_isSwitchOn;
        Provider.of<DeviceProvider>(context, listen: false).changeDeviceState(
            _myDevice, getDeviceValue(_myDevice.deviceType, _isSwitchOn));
      },
      onLongPress: () async {
        var dialogValue = await onLongPressDialogType(
            _myDevice.deviceType, _myDevice.currentValue ?? 0);
        if (dialogValue != null) {
          _dialogValue = dialogValue;
          Provider.of<DeviceProvider>(context, listen: false)
              .changeDeviceState(_myDevice, dialogValue);
        }
      },
      child: TweenAnimationBuilder(
        duration: Duration(milliseconds: 300),
        tween: ColorTween(
            begin:
                _isSwitchOn ? Theme.of(context).accentColor : Color(0xffe8e8e8),
            end: _isSwitchOn
                ? Theme.of(context).accentColor
                : Color(0xffe8e8e8)),
        builder: (context, value, child) {
          return Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: value,
              boxShadow: [
                BoxShadow(
                    color: _isSwitchOn
                        ? Theme.of(context).accentColor
                        : Color(0xffc5c5c5),
                    offset: Offset(4.0, 4.0),
                    blurRadius: 12.0,
                    spreadRadius: 1.0),
                BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4.0, -4.0),
                    blurRadius: 12.0,
                    spreadRadius: 1.0),
              ],
            ),
            child: child,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                child: _dialogValue != null
                    ? Text(
                        ((_myDevice.currentValue != null &&
                                    _myDevice.currentValue > 0)
                                ? _myDevice.currentValue
                                : "")
                            .toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: _isSwitchOn
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                        ))
                    : SizedBox.shrink(),
                alignment: Alignment.center),
            Expanded(
              child: RotationTransition(
                turns: _animation,
                child: Center(
                    child: SvgPicture.asset(
                  widget._device.iconAsset,
                  semanticsLabel: 'Device Icon',
                  color: _isSwitchOn
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                  height: 65,
                  width: 65,
                )),
              ),
            ),
            Row(
              mainAxisAlignment: _isSwitchOn
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.center,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    _myDevice.deviceName + " / " + _myDevice.nodeNo,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: _isSwitchOn
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}
