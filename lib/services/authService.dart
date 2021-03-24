import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:lumoshomes/models/account.dart';
import 'package:lumoshomes/models/room.dart';
import 'package:lumoshomes/services/databaseRepo.dart';
import 'package:lumoshomes/services/mainRepository.dart';
import 'package:lumoshomes/utils/globalVar.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User> get user => _auth.userChanges();
  // Stream<User> get user => _auth.userChanges();

  Future<bool> registerWithEmail(
      {String emailid, String password, Account account}) async {
    try {
      globalListOfRooms = [];
      var listOfRooms =
          await MainRepository().getLisOfRoomsByCustomerId(globalUserId);
      if (listOfRooms != null) {
        print('user id is correct !');
        // globalListOfRooms.addAll(listOfRooms);
        var userCredential = await _auth.createUserWithEmailAndPassword(
            email: emailid, password: password);
        var user = userCredential.user;

        if (!user.emailVerified) {
          await user.sendEmailVerification();
          print('verification email sent ------------------ :> ');
        }

        await Future(() async {
          Timer.periodic(Duration(seconds: 5), (timer) async {
            await _auth.currentUser.reload();
            var user = _auth.currentUser;
            if (user.emailVerified) {
              _auth.userChanges();
              print('------------------------------------- ***');
              print(' ---------- email verified ------------ ');
              print('------------------------------------- ***');
              timer.cancel();
            }
          });
        });

        await MainRepository().addAccountDataToDatabase(account);

        return true;
      } else {
        print('invalid < user id > while signup');
        return false;
      }
    } catch (error) {
      print('error while registeration: $error');
      if (_auth.currentUser != null) {
        _auth.signOut();
      }
      return false;
    }
  }

  Future<bool> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (err) {
      print('error white login: $err');
      return false;
    }
  }

  Future<Either<List<Room>, String>> verifyAdminId(
      String emailId, String password,
      {String userId}) async {
    try {
      var adminData = await MainRepository().getAdminIdAndPassword();
      var adminPassword = adminData['password'];
      var adminId = adminData['id'];
      if (adminPassword == password && adminId == emailId) {
        print('auth SUCCESSFULL !');
        if (userId != null) {
          var listOfRooms =
              await MainRepository().getLisOfRoomsByCustomerId(userId);
          if (listOfRooms != null && listOfRooms.length > 0) {
            print(' auth service: list of rooms present');
            return Left(listOfRooms);
          } else
            return Right('no id found');
        }
        return Left([]);
      } else {
        print('auth FAILED !');
        print('id is: $adminId');
        print('password is: $adminPassword');
        return Right('either id or password is wrong');
      }
    } catch (err) {
      print('error white login: $err');
      return Right('Server error ');
    }
  }

  Future<List<Room>> checkDatabaseAvailability() async {
    try {
      var listOfRooms = await DatabaseRepo().getAllRooms();
      var account = await DatabaseRepo().getAccountData();
      if (listOfRooms != null && listOfRooms.length > 0 && account != null) {
        globalUserId = account.userId;
        // print(' LOCAL DATABASE PEESENT');
        return listOfRooms;
      } else {
        if (globalUserId != null && globalUserId.isNotEmpty) {
          print(' ! it is signup !');

          //try to fetch from the cloud
          var uid = _auth.currentUser.uid;
          listOfRooms =
              await MainRepository().getLisOfRoomsByCustomerId(globalUserId);
          account = await MainRepository().getAccountData(globalUserId);

          if (listOfRooms != null && account != null) {
            print('list of rooms & account are not null ! ! ! ! ! ! ');
            //list of rooms from cloud is present
            await MainRepository().setUIDtoUserid(globalUserId, uid);
            // save to local database
            await DatabaseRepo().addListOfRoomsToDatabase(listOfRooms);
            await DatabaseRepo().setAccountData(account);
            return listOfRooms;
          } else {
            await signout();
            return null;
          }
        } else {
          // login ------------------------------
          print(' ! it is login !: ');
          // fetch from cloud for uid
          var accountAndRooms =
              await MainRepository().getListOfRoomsByUID(_auth.currentUser.uid);
          if (accountAndRooms == null) {
            throw 'account and room fetch return null';
          }
          listOfRooms = accountAndRooms.values.toList()[0];
          account = accountAndRooms.keys.toList()[0];
          if (listOfRooms != null && account != null) {
            // save to local database
            await DatabaseRepo().addListOfRoomsToDatabase(listOfRooms);
            await DatabaseRepo().setAccountData(account);
            globalUserId = account.userId;

            return listOfRooms;
          } else {
            print('no data is saved for this uid');
            signout();
            return null;
          }
        }
      }
    } catch (err) {
      print('error whild checkAvailability: $err');
      return null;
    }
  }

  Future signout() async {
    try {
      if (_auth.currentUser != null) {
        await _auth.signOut();
        await DatabaseRepo().deleteWholeLocalDatabase();
        globalListOfRooms = null;
        globalUserId = null;
        print('singout');
      }
    } catch (error) {
      print('signing out - ERROR: $error');
    }
  }
}
