import 'package:flutter/material.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      appBar: AppBar(
      automaticallyImplyLeading: false,
      iconTheme: IconThemeData(color: Colors.blueGrey, size: 40),
      backgroundColor: Colors.white,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal:2.0),
        child: Text(
          "hello,UserName",
          style: TextStyle(
              color: Color.fromRGBO(102, 102, 102, 1),
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      ),
    ),




    ),
    );
  }
}
