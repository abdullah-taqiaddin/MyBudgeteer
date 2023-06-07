import 'package:flutter/cupertino.dart';

class LanguageProvider extends ChangeNotifier{

  String language = 'en';

  void setLanguage(String language){
    this.language = language;
    notifyListeners();
  }
  //getters
  String get getLanguage => language;


}