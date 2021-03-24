import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lumoshomes/models/account.dart';
import 'package:lumoshomes/services/authService.dart';
import 'package:lumoshomes/utils/constants.dart';
import 'package:lumoshomes/utils/globalVar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> _scaffoldloginKey;
  bool _isLogin = true;

  TextEditingController _userNameController;
  TextEditingController _userIdController;

  TextEditingController _emailIdController;
  TextEditingController _passwordController;
  TextEditingController _addressController;
  TextEditingController _phoneNumberController;
  TextEditingController _documentIdController;

  bool _isLoading = false;
  int documentType = 0;
  GlobalKey<FormState> _formKey;
  clearCredentials() {
    _emailIdController.clear();
    _passwordController.clear();
    _userIdController.clear();
  }

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _emailIdController = TextEditingController();
    _passwordController = TextEditingController();
    _userIdController = TextEditingController();

    _addressController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _documentIdController = TextEditingController();
    _scaffoldloginKey = GlobalKey<ScaffoldState>();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldloginKey,
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
                    _isLogin ? 'Login' : 'Signup',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  _isLogin
                      ? SizedBox()
                      : Container(
                          margin: EdgeInsets.symmetric(vertical: 12),
                          child: TextFormField(
                            validator: (value) => value.length > 0 || _isLogin
                                ? null
                                : 'Enter your user id',
                            controller: _userIdController,
                            onChanged: (value) => globalUserId = value,
                            keyboardType: TextInputType.text,
                            style: TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 14.0),
                              prefixIcon: Icon(
                                Icons.security,
                                color: Theme.of(context).primaryColor,
                              ),
                              hintText: 'User Id',
                              hintStyle: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ),
                  _isLogin
                      ? SizedBox()
                      : Container(
                          margin: EdgeInsets.symmetric(vertical: 12),
                          child: TextFormField(
                            validator: (value) =>
                                value.length > 0 ? null : 'enter your name',
                            controller: _userNameController,
                            keyboardType: TextInputType.name,
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 14.0),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                              ),
                              hintText: 'Enter your Name',
                              hintStyle: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: TextFormField(
                      validator: (value) =>
                          value.length > 0 ? null : 'enter your email id',
                      controller: _emailIdController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 14.0),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Theme.of(context).primaryColor,
                        ),
                        hintText: 'Enter your Email',
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: TextFormField(
                      validator: (value) =>
                          value.length > 0 ? null : 'enter your password',
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
                        hintText: 'Enter your Password',
                        hintStyle: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  _isLogin
                      ? SizedBox()
                      : Container(
                          margin: EdgeInsets.symmetric(vertical: 12),
                          child: TextFormField(
                            validator: (value) =>
                                value.length > 0 ? null : 'enter your address',
                            controller: _addressController,
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                            keyboardType: TextInputType.streetAddress,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 14.0),
                              prefixIcon: Icon(
                                Icons.home,
                                color: Theme.of(context).primaryColor,
                              ),
                              hintText: 'Enter your Address',
                              hintStyle: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                  _isLogin
                      ? SizedBox()
                      : Container(
                          margin: EdgeInsets.symmetric(vertical: 12),
                          child: TextFormField(
                            validator: (value) => value.length == 10
                                ? null
                                : 'must contain 10 digits',
                            controller: _phoneNumberController,
                            style: TextStyle(color: Colors.black87),
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 14.0),
                              prefixIcon: Icon(
                                Icons.phone_iphone,
                                color: Theme.of(context).primaryColor,
                              ),
                              hintText: 'Enter your Phone Number',
                              hintStyle: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ),
                  _isLogin
                      ? SizedBox()
                      : Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          child: DropdownButton(
                            onChanged: (value) =>
                                setState(() => documentType = value),
                            hint: Text('choose document type'),
                            isExpanded: true,
                            icon: Icon(Icons.credit_card),
                            value: documentType,
                            items: [
                              DropdownMenuItem(
                                  child: Text('Aadhar Card'), value: 0),
                              DropdownMenuItem(
                                  child: Text('Pan Card'), value: 1)
                            ],
                          ),
                        ),
                  _isLogin
                      ? SizedBox()
                      : Container(
                          margin: EdgeInsets.symmetric(vertical: 12),
                          child: TextFormField(
                            validator: (value) => documentType == 0
                                ? (value.length != 12
                                    ? ' aadhar card must contain 12 digits'
                                    : null)
                                : value.length != 10
                                    ? ' pan card must contain 10 digits'
                                    : null,
                            controller: _documentIdController,
                            style: TextStyle(color: Colors.black87),
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 14.0),
                              prefixIcon: Icon(
                                FontAwesomeIcons.idCard,
                                color: Theme.of(context).primaryColor,
                              ),
                              hintText: documentType == 0
                                  ? 'Enter your aadhar no'
                                  : 'Enter your pan card no',
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
                        //--------------------------------------------- *
                        // await MainRepository().getListOfRooms('puppy');
                        // return;
                        //------------------------------------------- *
                        if (_formKey.currentState.validate()) {
                          var accountData = Account(
                              emailId: _emailIdController.text,
                              userId: _userIdController.text,
                              address: _addressController.text,
                              phoneNumber: _phoneNumberController.text,
                              userName: _userNameController.text,
                              authorizationDocumentType: documentType,
                              authorizationDocumentId:
                                  _documentIdController.text,
                              connectionDate: DateTime.now());
                          // login or signup
                          if (_isLogin) {
                            setState(() => _isLoading = true);
                            var result = await AuthService().loginWithEmail(
                                _emailIdController.text,
                                _passwordController.text);
                            if (result) {
                              print('login is successfull ');
                            } else {
                              clearCredentials();
                              _scaffoldloginKey.currentState
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  'Login Failed Wrong email or password',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ));
                              setState(() => _isLoading = false);
                              print('login is failed');
                            }
                            ;
                          } else {
                            setState(() => _isLoading = true);
                            var result = await AuthService().registerWithEmail(
                                emailid: _emailIdController.text,
                                password: _passwordController.text,
                                account: accountData);
                            if (result) {
                              print('signin is successfull ');
                            } else
                              print('signin is failed');
                          }
                        }
                      },
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              _isLogin ? 'LOGIN' : 'SIGNUP',
                              style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => _isLogin = !_isLogin);
                      _userIdController.clear();
                      _passwordController.clear();
                      _emailIdController.clear();
                    },
                    child: Container(
                      margin: EdgeInsets.all(8),
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: _isLogin
                                  ? 'Don\'t have an Account?  '
                                  : 'Already have an account? ',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: _isLogin ? 'Sign Up' : 'Login',
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
                  GestureDetector(
                    onTap: () {
                      //implement admin login
                      Navigator.of(context)
                          .pushNamed(RouteConstant.adminScreen);
                    },
                    child: Container(
                        margin: EdgeInsets.all(8),
                        alignment: Alignment.center,
                        child: Text(
                          'Login as administrator',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
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
