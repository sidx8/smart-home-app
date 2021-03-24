import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lumoshomes/models/account.dart';
import 'package:lumoshomes/services/databaseRepo.dart';
import 'package:lumoshomes/utils/styleConstant.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String getDocumentFromType(int documentValue) {
    switch (documentValue) {
      case 0:
        return 'Aadhar Card';
        break;
      case 1:
        return 'Pan Card';
        break;
      default:
        return 'No document';
    }
  }

  customListTile(IconData iconData, String title, String subtitle,
          BuildContext context) =>
      ListTile(
        leading: Icon(
          iconData,
          size: 28,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            height: 2,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        subtitle: Text(subtitle),
      );

  customDivider(BuildContext context) => Divider(
        indent: 15,
        endIndent: 15,
        thickness: 1.5,
        color: Theme.of(context).appBarTheme.color,
        height: 30,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
        ),
      ),
      body: FutureBuilder(
        future: DatabaseRepo().getAccountData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            Account account = snapshot.data;
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30, bottom: 35),
                  child: Center(
                    child: ListTile(
                      leading: Icon(
                        Icons.account_circle,
                        color: Theme.of(context).appBarTheme.color,
                        size: 55,
                      ),
                      title: Text(
                        account.userName,
                        style: TextStyle(
                          height: 2,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                          'Connection Date: ${DateFormat.yMd().format(account.connectionDate)}'),
                      trailing: Container(
                        height: 50,
                        width: 110,
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          color: Theme.of(context).appBarTheme.color,
                          onPressed: () async {
                            print('Account Edit Button Pressed');
                            var newName = await showDialogView(context);
                            setState(() {
                              if (newName != null) {
                                account.userName = newName;
                              }
                            });
                          },
                          child: Text(
                            'EDIT',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                customListTile(
                    Icons.call, account.phoneNumber, 'Mobile', context),
                customDivider(context),
                customListTile(Icons.email, account.emailId, 'Email', context),
                customDivider(context),
                customListTile(
                    Icons.verified_user, account.userId, 'Devce id', context),
                customDivider(context),
                customListTile(
                    Icons.description,
                    getDocumentFromType(account.authorizationDocumentType),
                    'Document type',
                    context),
                customDivider(context),
                customListTile(Icons.credit_card,
                    account.authorizationDocumentId, 'Document Id', context),
              ],
            );
          }
        },
      ),
    );
  }

  Future<String> showDialogView(BuildContext context) async {
    bool _isError = false;
    String errorMessage;
    var _nameController = TextEditingController();

    return await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: StatefulBuilder(builder: (context, setState) {
            return Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Enter your name',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                    TextField(
                      controller: _nameController,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          enabledBorder: StyleConstant.outlineInputBorder,
                          labelText: 'your name',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.black.withOpacity(.7),
                          )),
                    ),
                    SizedBox(height: 16),
                    RaisedButton(
                      onPressed: () async {
                        var name = _nameController.text;
                        if (name != null && name.isNotEmpty) {
                          var check = await DatabaseRepo().changeUserName(name);
                          if (check) {
                            Navigator.pop(context, name);
                          } else {
                            setState(() {
                              errorMessage = 'error while updating your name';
                              _isError = true;
                            });
                          }
                        } else {
                          setState(() {
                            errorMessage = 'Name can\'t be empty';
                            _isError = true;
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Text('Update',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                    _isError
                        ? Padding(
                            padding: EdgeInsets.all(8),
                            child: Center(
                                child: Text(errorMessage,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red,
                                    ))))
                        : SizedBox(),
                  ],
                ));
          }),
        );
      },
    );
  }
}
