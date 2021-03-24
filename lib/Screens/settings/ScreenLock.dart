import 'package:flutter/material.dart';
import 'package:lumoshomes/Providers/deviceProvider.dart';
import 'package:lumoshomes/Screens/homepage/homePage.dart';
import 'package:lumoshomes/models/room.dart';
import 'package:provider/provider.dart';

class ScreenLock extends StatefulWidget {
  final String screenPassword;
  ScreenLock(this.screenPassword);

  @override
  _ScreenLockState createState() => _ScreenLockState();
}

class _ScreenLockState extends State<ScreenLock> {
  TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Back'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your password',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: _passwordController,
                  validator: (value) =>
                      value.isNotEmpty && value == widget.screenPassword
                          ? null
                          : 'Password is invalid',
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Password',
                  ),
                  obscureText: true,
                ),
              ),
            ),
            RaisedButton(
                textColor: Colors.white,
                child: Text(
                  'Unlock',
                ),
                onPressed: () {
                  print(_passwordController.text);
                  print(widget.screenPassword);
                  if (_formKey.currentState.validate()) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) => DeviceProvider(),
                        child: Container(
                          child: HomePage2(),
                        ),
                      ),
                    ));
                  } else
                    _passwordController.clear();
                }),
          ],
        ),
      ),
    );
  }
}
