import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:testapp/model/barchart_model.dart';
import 'package:testapp/model/budget.dart';
import 'package:testapp/view/budget_page.dart';
import 'package:testapp/view/expense_page.dart';
import '../viewmodel/database_provider.dart';

class StatisticsPage extends StatelessWidget {
  StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Provider.of<DatabaseProvider>(context).getBudgetsByMonth(currentMonthIndex + 1, 2023),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Budget> budgets = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return Budget.fromJson(data);
          }).toList();
          {
            if (snapshot.hasData) {
              List<Budget> budgets = snapshot.data!.docs.map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return Budget.fromJson(data);
              }).toList();

              // Use the budgets data in the UI
              double totalAmount = budgets.fold(
                  0, (sum, budget) => sum + budget.amount);
              //double totalTotal = budgets.fold(0, (sum, budget) => sum + budget.totalSpent);
              // DateTime latestDate = budgets.isNotEmpty ? budgets.last.budgetDate : DateTime.now();
              return Builder(builder: (context) {
                return Scaffold(
                  body: Container(
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 50, left: 20),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: Color(0XFF145756),
                                      size: 40,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      "Statistics",
                                      style: TextStyle(
                                          color: Color(0XFF145756),
                                          fontSize: 50,
                                          fontFamily: 'K2D',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 160,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey[200],

                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          /*Text(
                                      "Pie",
                                      style: TextStyle(
                                        fontFamily: "K2D",
                                        fontSize: 18,
                                        color: Color(0XFF145756),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),*/
                                          Container(
                                            width: 140,
                                            height: 120,
                                            child: charts.PieChart(
                                              _createSampleData(),
                                              animate: true,
                                              defaultRenderer: charts
                                                  .ArcRendererConfig(
                                                arcWidth: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Container(
                                    width: 160,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey[200],

                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Total",
                                            style: TextStyle(
                                                fontFamily: "K2D",
                                                fontSize: 20,
                                                color: Color(0XFF145756),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 20,),
                                          Text(
                                            "${totalAmount}",
                                            style: TextStyle(
                                                fontFamily: "K2D",
                                                fontSize: 25,
                                                color: Colors.lime,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 35.0,
                                right: 35.0,
                                bottom: 20.0,
                                top: 20.0,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        "Expenses Progress",
                                        style: TextStyle(
                                            fontFamily: "K2D",
                                            fontSize: 18,
                                            color: Color(0XFF145756),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        height: 25,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: Color.fromRGBO(123, 203, 201, 1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Monthly",
                                            style: TextStyle(
                                                fontFamily: "K2D",
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 18.0, right: 18.0, bottom: 15.0, top: 8.0),
                              child: Container(
                                height: 300,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(25)),
                                child: MyChart(data: spendingData),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
            }
          }

          double totalAmount = budgets.fold(0, (sum, budget) => sum + budget.amount);

          return Builder(builder: (context) {
            return Scaffold(
              body: Container(
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rest of the code
                        // ...
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        }

        // Return a fallback widget or an empty container
        return CircularProgressIndicator(); // Replace with your desired fallback widget
      },
    );
  }

}

List<SpendingData> spendingData = [
  SpendingData(month: 'January', totalSpent: 900, budget: 500),
  SpendingData(month: 'February', totalSpent: 450, budget: 450),
  SpendingData(month: 'March', totalSpent: 600, budget: 500),
  SpendingData(month: 'April', totalSpent: 550, budget: 600),
  SpendingData(month: 'May', totalSpent: 30, budget: 400),
  SpendingData(month: 'June', totalSpent: 0, budget: 600),
  SpendingData(month: 'July', totalSpent: 0, budget: 500),
  SpendingData(month: 'August', totalSpent: 0, budget: 400),
  SpendingData(month: 'September', totalSpent: 0, budget: 600),
  SpendingData(month: 'October', totalSpent: 0, budget: 450),
  SpendingData(month: 'November', totalSpent: 0, budget: 500),
  SpendingData(month: 'December', totalSpent: 0, budget: 550),
];

List<charts.Series<PieData, String>> _createSampleData() {
  final data = [
    //for budget
    PieData('Category A', 25, Colors.yellow),
    PieData('Category B', 15, Colors.cyan),
    PieData('Category C', 20, Colors.greenAccent),
    PieData('Category D', 40, Colors.lime),
    PieData('Category E', 10, Color.fromRGBO(52, 207, 179, 0.38)),
    //PieData('Category F', 10, Color.fromRGBO(255, 107, 53, 1)),
  ];

  return [
    charts.Series<PieData, String>(
      id: 'pieData',
      domainFn: (PieData data, _) => data.category,
      measureFn: (PieData data, _) => data.value,
      colorFn: (PieData data, _) => charts.ColorUtil.fromDartColor(data.color),
      data: data,
      labelAccessorFn: (PieData data, _) => '${data.category}: ${data.value}%',
    ),
  ];
}

class PieData {
  final String category;
  final int value;
  final Color color;

  PieData(this.category, this.value, this.color);
}

