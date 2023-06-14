import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:testapp/viewmodel/database_provider.dart';
import 'package:testapp/viewmodel/expense_date_provider.dart';


import 'budget_page.dart';

class ExpenseTab extends StatefulWidget {
  const ExpenseTab({Key? key}) : super(key: key);

  @override
  State<ExpenseTab> createState() => _ExpenseTabState();
}




String _selectedYear = DateFormat.y().format(DateTime.now()).toString();

class _ExpenseTabState extends State<ExpenseTab> {

  late int currentMonthIndex;

  bool hasData = false;
  void initState() {
    super.initState();
    _selectedYear = DateFormat.y().format(DateTime.now()).toString();
  }

  @override
  Widget build(BuildContext context) {
    currentMonthIndex = Provider.of<ExpenseDateProvider>(context).month;
    _selectedYear =   Provider.of<ExpenseDateProvider>(context).year.toString();


    return StreamBuilder<Map<DateTime, List<QueryDocumentSnapshot<Map<String, dynamic>>>>>(
      stream: Provider.of<DatabaseProvider>(context).getExpensesByDate(currentMonthIndex + 1,2023).asStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error'),
          );
        }
        if(snapshot.hasData && snapshot.data != null){
          hasData = true;
        }
        print("has data: $hasData");
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: isDark?Color.fromRGBO(159, 79, 248, 1):Color.fromRGBO(123, 203, 201, 1),
                    ),
                    child: GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              currentMonthIndex = (currentMonthIndex - 1) % 11;
                              Provider.of<ExpenseDateProvider>(context,listen: false).setMonth(currentMonthIndex);
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
                                  .format(DateTime(int.parse(_selectedYear), currentMonthIndex + 1, 1))
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
                                currentMonthIndex = (currentMonthIndex + 1) % 11;
                                Provider.of<ExpenseDateProvider>(context,listen: false).setMonth(currentMonthIndex);
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
                              color: isDark?Color.fromRGBO(159, 79, 248, 1):Color.fromRGBO(123, 203, 201, 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: DropdownButton<String>(
        dropdownColor: Colors.teal[100],
        value: _selectedYear,
        onChanged: (String? newValue) {
        print("newValue: $newValue");
        setState(() {
        hasData = false;
        _selectedYear = newValue!;
        });
        },
        items: <String>[
        DateFormat.y().format(DateTime.now()).toString(),
        (DateTime.now().year + 1).toString(),
        ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
        value: value,
        child: Row(
        children: [
        SizedBox(width: 15,),
        Text(
        value, // Use the current value, not _selectedYear
        style: TextStyle(
        fontFamily: "K2D",
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.white,
        ),
        ),
        ],
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
            Container(
              //make the height of the list view dynamic but not more than 50% of the screen
              height: MediaQuery.of(context).size.height * 0.55,

              child: SizedBox(
                child: hasData?
                ListView.builder(
                  itemCount: snapshot.data!.keys.length,
                  itemBuilder: (BuildContext context, int index) {
                    if(snapshot.data == null){
                      return Center(
                        child: Text('No Data',style: TextStyle(
                          fontFamily: "K2D",
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),),
                      );
                    }
                    var keys = snapshot.data!.keys.toList();
                    //
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
                ): Center(
                  child: Text('No Data',style: TextStyle(
                    fontFamily: "K2D",
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),),
                )
              ),
            ),
            //add a sizedbox to the footer
            SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }


  Widget buildExpenseExpansionTile(DateTime dateTime, String total, var expenseList) {
    dateTime = DateTime(dateTime.year, dateTime.month - 1, dateTime.day);

    var primary = TextStyle(
      fontFamily: "K2D",
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.white,
    );
    var secondary = TextStyle(
      fontFamily: "K2D",
      fontWeight: FontWeight.w300,
      fontSize: 18,
      color: Colors.white,
    );
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
                          bool enditem = index == expenseList.length - 1;

                          return Column(
                            children: [
                              /*ListTile(

                                leading:Icon(Icons.payment,color: Colors.white,),
                                title:Text(expenseList![index]['name'].toString(), style: primary),
                                subtitle: Column(
                                  children: [
                                    Text(expenseList[index]['budgetName'].toString(), style: secondary),
                                    Text(expenseList[index]['amount'].toString() , style: primary,),
                                  ],
                                ),
                              ),*/
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [

                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(width: 15,),
                                          Text(expenseList[index]['name'].toString(), style: primary),
                                          SizedBox(width: 15,),
                                          Text(expenseList[index]['budgetName'].toString(), style: secondary),
                                          SizedBox(width: 15,),
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 15,),
                                      Text(expenseList[index]['amount'].toString() , style: primary,),
                                      SizedBox(width: 15,),
                                    ],
                                  ),IconButton(
                                      onPressed: () {
                                        deleteExpense(expenseList[index]['budgetId'],expenseList[index]['id']);
                                        },
                                      icon: Icon(Icons.delete, size: 30, color: Colors.white,)
                                  ),
                                ],
                              ),
                              !enditem? Divider(
                                color: Colors.white,
                                endIndent: 150,
                                indent: 10,
                              ):Container(
                                height: 0,
                              )
                            ],
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

  void deleteExpense(budgetId,expenseId){

    Provider.of<DatabaseProvider>(context,listen: false).deleteExpense(budgetId, expenseId);
  }

}

