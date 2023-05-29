import 'package:flutter/cupertino.dart';

class DateProvider extends ChangeNotifier{

  int month = DateTime.now().month;
  int year = DateTime.now().year;

  void setMonth(int month){
    this.month = month;
    notifyListeners();
  }
  void setYear(int year){
    this.year = year;
    notifyListeners();
  }
  //getters
  int get getMonth => month;
  int get getYear => year;


}