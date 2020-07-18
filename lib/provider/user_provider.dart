import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:pratichabi/models/user.dart';
import 'package:pratichabi/resources/firebase_repository.dart';

class UserProvider with ChangeNotifier{
  User _user;

  FirebaseRepository _firebaseRepository = FirebaseRepository();

  User get getUser => _user;

  void refreshUser() async{
    User user = await _firebaseRepository.getUserDetails();
    _user = user;
    notifyListeners();
  }
}