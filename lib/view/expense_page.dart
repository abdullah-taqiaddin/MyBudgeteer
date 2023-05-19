import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:testapp/viewmodel/database_provider.dart';

import 'package:testapp/viewmodel/localization.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class expenseTab extends StatefulWidget {
  const expenseTab({Key? key}) : super(key: key);

  @override
  State<expenseTab> createState() => _expenseTabState();
}

int currentMonthIndex = DateTime.now().month +1 ;
String _selectedYear = DateFormat.y().format(DateTime.now()).toString();

class _expenseTabState extends State<expenseTab> {
  void initState() {
    super.initState();
    _selectedYear = DateFormat.y().format(DateTime.now()).toString();
  }


  @override
  Widget build(BuildContext context) {
    print("current index: ${currentMonthIndex}");
    return StreamBuilder<Map<DateTime, List<QueryDocumentSnapshot<Map<String, dynamic>>>>>(
      stream: Provider.of<DatabaseProvider>(context).getAllExpensesDates(currentMonthIndex+1).asStream() ,
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.hasError){
          return Center(child: Text('Error'),);
        }
        listBuilder(snapshot);
        print(snapshot.data);
        return Column(children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top:20,
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
                                    .format(DateTime(
                                        DateTime.now().month, currentMonthIndex + 1))
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
                    //Years
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
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
                                        newValue = newValue;
                                      });
                                    },
                                    items: <String>[
                                      DateFormat.y()
                                          .format(DateTime.now())
                                          .toString(),
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
            ],
          ),
          SizedBox(
            height: 0.2,
          ),
          Container(
              width: 344,
              height: 485,
              child: listBuilder(snapshot)
          ),
        ]);
      }
    );
  }
  Widget listBuilder(AsyncSnapshot<Map<DateTime, List<QueryDocumentSnapshot<Map<String, dynamic>>>>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.keys.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        var keys = snapshot.data!.keys.toList();
        DateTime key = keys[index];
        double totalAmount = 0.0;
        var list = [];
        snapshot.data!.forEach((key, value) {
          list = value.map((e) => e.data()!).toList();
        });
        for(int i = 0 ; i< list.length ;i++){
          totalAmount += list[i]['amount'];
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildExpenseExpansionCard(Color.fromRGBO(52, 207, 179, 1),Color.fromRGBO(33, 137, 118, 1), key, totalAmount.toString(), {}),
        );
      },

    );
  }

  Widget buildExpenseExpansionCard(
      Color color1, Color color2, DateTime dateTime, String total, Map<String, dynamic> expenses) {
    bool isExpanded = false;

    return Container(
      width: 500,
      decoration: BoxDecoration(
        color: color1,
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
              color: color2,
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
                  "$total\$",
                  style: TextStyle(
                      fontFamily: "K2D",
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.white),
                )
              ],
            ),
          ),
          (isExpanded == true)? Container(
            height: 200, // Adjust the height as needed
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                String expenseTitle = expenses.keys.toList()[index];
                dynamic expenseValue = expenses.values.toList()[index];
                return ListTile(
                  title: Text(expenseTitle),
                  subtitle: Text('$expenseValue\$'),
                );
              },
            ),
          )
              : SizedBox(), // Empty SizedBox when not expanded
          Container(
            height: 25,
            child: IconButton(
              color: Colors.white,
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });// Toggle the expanded state
              },
              icon: (isExpanded == true) ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
            ),
          ),
        ],
      ),
    );
  }


  //we need to build an expansionpanellist for each date using the buildExpenseCard design above, them each inner list will contain the list of expenses for that day, to get the days which have expenses we need to use the getAllExpensesDates(int month) function


}

