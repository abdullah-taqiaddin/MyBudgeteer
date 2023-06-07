import 'package:flutter/cupertino.dart';

class ThemeProvider extends ChangeNotifier{

  bool isDark = false;

  void setTheme(bool isDark){
    this.isDark = isDark;
    notifyListeners();
  }
  //getters
  bool get getTheme => isDark;


}