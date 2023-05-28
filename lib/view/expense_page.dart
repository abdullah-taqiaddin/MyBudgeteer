import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:testapp/model/expense.dart';
import 'package:testapp/viewmodel/database_provider.dart';

import 'package:testapp/viewmodel/localization.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExpenseTab extends StatefulWidget {
  const ExpenseTab({Key? key}) : super(key: key);

  @override
  State<ExpenseTab> createState() => _ExpenseTabState();
}

int currentMonthIndex = DateTime.now().month + 1;
String _selectedYear = DateFormat.y().format(DateTime.now()).toString();

class _ExpenseTabState extends State<ExpenseTab> {
  void initState() {
    super.initState();
    _selectedYear = DateFormat.y().format(DateTime.now()).toString();
  }

  @override
  Widget build(BuildContext context) {
    print("current index: $currentMonthIndex");
    return StreamBuilder<Map<DateTime, List<QueryDocumentSnapshot<Map<String, dynamic>>>>>(
      stream: Provider.of<DatabaseProvider>(context).getAllExpensesDates(currentMonthIndex +1).asStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error'),
          );
        }
        print("data: ---> ${snapshot.data!}");
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onHorizontalDragEnd: (DragEndDetails details) {
                      if (details.primaryVelocity! > 0) {
                        setState(() {
                          currentMonthIndex = (currentMonthIndex - 1) % 12;
                        });
                      } else if (details.primaryVelocity! < 0) {
                        setState(() {
                          currentMonthIndex = (currentMonthIndex + 1) % 12;
                        });
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Color.fromRGBO(123, 203, 201, 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentMonthIndex = (currentMonthIndex - 1) % 12;
                              });
                            },
                            child: Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          Center(
                            child: Text(
                              DateFormat.MMMM()
                                  .format(DateTime(DateTime.now().year, currentMonthIndex + 1))
                                  .toString(),
                              style: TextStyle(
                                fontFamily: "K2D",
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentMonthIndex = (currentMonthIndex + 1) % 12;
                              });
                            },
                            child: Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  // Years
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          height: 40,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Color.fromRGBO(123, 203, 201, 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.teal[100],
                                  value: _selectedYear,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedYear = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    DateFormat.y().format(DateTime.now()).toString(),
                                    (DateTime.now().year + 1).toString(),
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          fontFamily: "K2D",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 0.2,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: snapshot.data!.keys.length,
                itemBuilder: (BuildContext context, int index) {
                  var keys = snapshot.data!.keys.toList();
                  DateTime key = keys[index];
                  double totalAmount = 0.0;
                  var expenseList = [];
                  expenseList = snapshot.data![key]!.toList();

                  //calculate the total amount of that day
                  for (int i = 0; i < expenseList.length; i++) {
                    totalAmount += expenseList[i]['amount'];
                  }

                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      bottom: 15,
                      right: 35,
                      left: 35,
                    ),
                    child: buildExpenseExpansionTile(
                      key,
                      totalAmount.toString(),
                      expenseList,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildExpenseExpansionTile(
      DateTime dateTime,
      String total,
      var expenseList,
      ) {
    print(expenseList);
    return Container(
      width: 500,
      decoration: BoxDecoration(
        color: Color(0xFF34cfb3),

        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(33, 137, 118, 1),
            ),
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  DateFormat('E, d/M/y').format(dateTime).toString(),
                  style: TextStyle(
                    fontFamily: "K2D",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Text(
                  "Total:",
                  style: TextStyle(
                      fontFamily: "K2D",
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "${total}\$",
                  style: TextStyle(
                      fontFamily: "K2D",
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.white),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              collapsedTextColor: Colors.white,
              textColor: Colors.white,
              iconColor: Colors.white,
              collapsedBackgroundColor:
              Color(0xFF34cfb3).withOpacity(0.6),
              backgroundColor: Color(0xFF34cfb3),
              title: Text(
                'Show Expenses',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                Container(
                    height: 200,
                    child: ListView.builder(
                        itemCount: expenseList.length,
                        itemBuilder:(BuildContext context,int index){
                          Timestamp timstamp = expenseList[index]['expenseDate'];
                          DateTime date = timstamp.toDate();
                          return ListTile(
                            leading:Text(expenseList![index]['name'].toString()),
                            trailing:Text(expenseList[index]['amount'].toString()),
                            title:Text( DateFormat("yyyy/MM/dd").format(date).toString()),
                          );
                        }
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

