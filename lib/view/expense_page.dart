import 'package:flutter/material.dart';
import 'package:testapp/component/bottom_container.dart';
import 'package:testapp/component/right_drawer.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({Key? key}) : super(key: key);

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              iconTheme: IconThemeData(color: Colors.blueGrey, size: 40),
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                "Expense",
                style: TextStyle(
                    color: Color.fromRGBO(102, 102, 102, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            endDrawer: RightDrawer(
              selectedIndex: _selectedIndex,
              onItemTapped: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
            backgroundColor: Colors.grey[100],
            body: Column(children: [
              Container(
                width: 500,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Row(
                          children: [
                            Text(
                              "E X P E N S E",
                              style: TextStyle(
                                  color: Color.fromRGBO(102, 102, 102, 1),

                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    /* Center(
                      child: Container(
                        height: 40,
                        width: 165,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Color.fromRGBO(92, 102, 114, 1)),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                              size: 30,
                            ),
                            Text(
                              "July",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                    )*/
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Card ${index + 1}'),
                      ),
                    );
                  },
                ),
              ),
              Center(
                  child:BottomContainer(color:  Color.fromRGBO(58, 67, 94, 1),)
              ),
            ])));
  }
}
