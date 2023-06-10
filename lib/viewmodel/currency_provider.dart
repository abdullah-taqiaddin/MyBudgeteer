import 'package:flutter/cupertino.dart';

class CurrencyProvider extends ChangeNotifier{

  String currency = "JD (JOD)";

  void setCurrency(String currency){
    this.currency = currency;
    notifyListeners();
  }
  //getters
  String get getCurrency => currency;


}