// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/view/budget_page.dart';
import 'package:testapp/view/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:testapp/viewmodel/auth_provider.dart';
import 'package:testapp/viewmodel/database_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:testapp/viewmodel/date_provider.dart';
import 'package:testapp/viewmodel/expense_date_provider.dart';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final SharedPreferences prefs = await _prefs;

  runApp(
    MultiProvider(
      providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider(),)
      ,ChangeNotifierProvider(create: (_) => DatabaseProvider())
      ,ChangeNotifierProvider(create: (_) => DateProvider())
      ,ChangeNotifierProvider(create: (_) => ExpenseDateProvider())
    ]
      ,child: MyApp(ref: prefs,),)
  );

}

class MyApp extends StatefulWidget {
  final SharedPreferences ref;

  MyApp({required this.ref});
  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  late SharedPreferences localstorageref;
  Widget routeWidget = loginPage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localstorageref = widget.ref;
  }

  setLocale(Locale locale) {
    setState(() {
       _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget routeWidget = checkUser();
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      debugShowCheckedModeBanner: false,
      home: routeWidget,
    );
  }

  Widget checkUser(){
    if((localstorageref.getBool("loggedIn")) == true){
      var user = FirebaseAuth.instance.currentUser;
      print(user);
      Provider.of<AuthProvider>(context).setUser(user);
      return BudgetPage();
    }
    return loginPage();
  }

}


