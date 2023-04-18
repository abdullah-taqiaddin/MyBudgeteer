import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testapp/component/bottom_container.dart';
import 'package:testapp/component/right_drawer.dart';
import 'package:testapp/view/budget_page.dart';

class expenseTab extends StatefulWidget {
  const expenseTab({Key? key}) : super(key: key);

  @override
  State<expenseTab> createState() => _expenseTabState();
}


final gradient1 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color.fromRGBO(32, 162, 162, 1),
    Color.fromRGBO(34, 165, 162, 1),
    Color.fromRGBO(50, 210, 163, 1),
  ],
);

final gradient2 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color.fromRGBO(0, 78, 137, 1),
    Color.fromRGBO(26, 101, 158, 1),
    Color.fromRGBO(75, 158, 184, 1),
    Color.fromRGBO(101, 129, 168, 1),
    //Color.fromRGBO(180, 210, 237, 1),
  ],
);


int currentMonthIndex = DateTime.now().month - 1;
int MonthIndex = 0;
String? _selectedYear;

class _expenseTabState extends State<expenseTab> {
  void initState() {
    super.initState();
    _selectedYear = DateFormat.y().format(DateTime.now()).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Months
              Container(
                height: 40,
                width: 190,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color.fromRGBO(123, 203, 201, 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          currentMonthIndex = (currentMonthIndex - 1) % 12;
                        });
                      },
                      icon: Icon(
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
                    IconButton(
                      onPressed: () {
                        setState(() {
                          currentMonthIndex = (currentMonthIndex + 1) % 12;
                        });
                      },
                      icon: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
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
                        color: Color.fromRGBO(123, 203, 201, 1)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: DropdownButton<String>(
                              dropdownColor:Colors.teal[100],
                              value: _selectedYear,
                              onChanged: (String? newValue) {
                                setState(() {
                                  newValue = newValue;
                                });
                              },
                              items: <String>[
                                DateFormat.y().format(DateTime.now()).toString(), (DateTime.now().year + 1).toString(),
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
                                color:Colors.white,
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
        ],
      ),
      SizedBox(
        height: 0.2,
      ),
      Container(
          width: 344,
          height: 485,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            //cardData is for testing purposes only, itll be a firebase request and mapping from JSON
            itemBuilder: (BuildContext context, int index) {
              //final int firstCardIndex = index ;
              //final int secondCardIndex = index * 2 + 1;

/*
                * when index is 0, set the colors as is and set lastcolor to secondCardColor for comparison,
                * next time it checks last color if its the secondCardColor,it switches, and so on
                * */
              //TODO:LOOK FOR A WAY TO KEEP COLORS CONTSTANT,FLUTTER KEEPS CHANING COLORS CUZ IT BUILDS THE LIST DYNAMICALLY

              final Widget ExpenseCard1 = buildExpenseCard(gradient1,
                  DateTime(DateTime.daysPerWeek), "Food", "100", "KFC");
              final Widget ExpenseCard2 = buildExpenseCard(
                  gradient2, DateTime(2000), "Shopping", "200", "ZARA");

              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [ExpenseCard1, SizedBox(height: 10), ExpenseCard2],
                ),
              );
            },
          )),
    ]);
  }
}

Widget buildExpenseCard(Gradient gradient, DateTime dateTime,
    String budgetCategory, String total, String description) {
  return Container(
    width: 300,
    height: 140,
    decoration: BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(20),
    ),
    padding: EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //date
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40), gradient: gradient),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              DateFormat.yMd().format(DateTime.now()).toString(),
              style: TextStyle(
                  fontFamily: "K2D",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Budget category
            Text(
              budgetCategory,
              style: TextStyle(
                  fontFamily: "K2D",
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(),
            //total
            Text(
              "\$ $total",
              style: TextStyle(
                  fontFamily: "K2D", fontSize: 16, color: Colors.white),
            ),
          ],
        ),
        SizedBox(height: 8),
        //description
        Text(
          description,
          style:
              TextStyle(fontFamily: "K2D", fontSize: 12, color: Colors.white),
        )
      ],
    ),
  );
}
