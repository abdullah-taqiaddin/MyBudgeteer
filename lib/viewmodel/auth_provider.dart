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
}