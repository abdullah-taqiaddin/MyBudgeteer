import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/view/budget_page.dart';
import 'package:testapp/view/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:testapp/viewmodel/auth_provider.dart';

late Widget home;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Check if the user is already authenticated
  User? user = FirebaseAuth.instance.currentUser;
  home = user == null ? loginPage() : BudgetPage();

  // Check if saved user credentials are available and use them for auto-login
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userEmail = prefs.getString('userEmail');
  String? userPassword = prefs.getString('userPassword');

  if (userEmail != null && userPassword != null) {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: userEmail, password: userPassword);
      home = BudgetPage();
    } catch (e) {
      // Ignore errors and fall back to the default home widget
    }
  }
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return home;
  }
}
