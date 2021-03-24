import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:sembast/sembast_io.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._();
  static get instance => _instance;

  AppDatabase._();

  Completer<sembast.Database> _dbOpenCompleter;

  Future<sembast.Database> get database async {
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      _openDatabase();
    }
    return _dbOpenCompleter.future;
  }

  Future _openDatabase() async {
    // print('open database alled');
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/userData.db';
    final database = await databaseFactoryIo.openDatabase(path);
    _dbOpenCompleter.complete(database);
    // print('Database opened ');
  }
}
