import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier{

  UserCredential? _userCredential;

  UserCredential? get userCredential => _userCredential;

  void setUserCredentials(UserCredential? credential){
    _userCredential = credential;
    notifyListeners();
  }

  void removeUserCredentials(){
    _userCredential = null;
    notifyListeners();
  }

  User? _user;
  User? get user => _user;

  void setUser(User? user){
      _user = user;
      notifyListeners();

  }

  void removeUser(){
    if(_user != null){
      _user = null;
    }
  }

}