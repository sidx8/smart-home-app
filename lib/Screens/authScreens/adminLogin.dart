import 'package:flutter/material.dart';
import 'package:lumoshomes/Screens/authScreens/adminHomePage.dart';
import 'package:lumoshomes/services/authService.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key key}) : super(key: key);

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _adminIdController;
  TextEditingController _userIdController;
  TextEditingController _passwordController;
  GlobalKey<FormState> _formKey;
  bool _isLoading = false;
  bool _isUpdate = false;

  clearCredentials() {
    _adminIdController.clear();
    _passwordController.clear();
    _userIdController.clear();
  }

  @override
  void initState() {
    super.initState();
    _adminIdController = TextEditingController();
    _passwordController = TextEditingController();
    _userIdController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Admin Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  _isUpdate
                      ? Container(
                          margin: EdgeInsets.symmetric(vertical: 12),
                          child: TextFormField(
                            validator: (value) =>
                                value.length > 0 ? null : 'Enter  customer id',
                            controller: _userIdController,
                            keyboardType: TextInputType.name,
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 14.0),
                              prefixIcon: Icon(
                                Icons.people,
                                color: Theme.of(context).primaryColor,
                              ),
                              hintText: 'Customer Id',
                              hintStyle: TextStyle(color: Colors.black54),
                            ),
                          ),
                        )
                      : SizedBox(),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: TextFormField(
                      validator: (value) =>
                          value.length > 0 ? null : 'Enter  admin id',
                      controller: _adminIdController,
                      keyboardType: TextInputType.name,
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 14.0),
                        prefixIcon: Icon(
                          Icons.security,
                          color: Theme.of(context).primaryColor,
                        ),
                        hintText: 'Admin Id',
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: TextFormField(
                      validator: (value) =>
                          value.length > 0 ? null : 'enter password',
                      controller: _passwordController,
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 14.0),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColor,
                        ),
                        hintText: 'Enter Admin Password',
                        hintStyle: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 25.0),
                    child: RaisedButton(
                      elevation: 5.0,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      onPressed: () async {
                        // Navigator.of(context).pushNamed(
                        //     RouteConstant.adminHomePage,
                        //     arguments: {'isUpdate': _isUpdate});
                        // return;
                        if (_formKey.currentState.validate()) {
                          setState(() => _isLoading = true);
                          print('use id : ${_userIdController.text}');

                          var isAuthenticated = await AuthService()
                              .verifyAdminId(_adminIdController.text,
                                  _passwordController.text,
                                  userId: _isUpdate
                                      ? _userIdController.text
                                      : null);

                          setState(() => _isLoading = false);

                          isAuthenticated.fold((listOfRooms) async {
                            await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AdminHomePage(
                                  listOfRooms, _userIdController.text),
                            ));
                            clearCredentials();
                          }, (error) {
                            print('authintication failed');
                            clearCredentials();
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                'Authentication Failed: $error',
                                style: TextStyle(fontSize: 16),
                              ),
                            ));
                          });
                        }
                      },
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              _isUpdate ? 'CUSTOM LOGIN' : 'LOGIN',
                              style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _isUpdate = !_isUpdate),
                    child: Container(
                      margin: EdgeInsets.all(8),
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: _isUpdate
                                  ? 'Add new customer ? '
                                  : 'Update customer data ?  ',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: _isUpdate ? 'Login' : 'Custom Login',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
