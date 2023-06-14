// ignore_for_file: prefer_const_constructors, unnecessary_new, sort_child_properties_last

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:testapp/model/budget.dart';
import 'package:testapp/view/budget_page.dart';
import 'package:testapp/viewmodel/database_provider.dart';

import '../viewmodel/language_provider.dart';
import '../viewmodel/localization.dart';

class DummyObject {
  const DummyObject(this.month, this.y1, this.y2);
  final int month;
  final int y1;
  final int y2;
}

//props
bool hasData = false;

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});
  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    String language = 'en';
    language = Provider.of<LanguageProvider>(context).language;

    return StreamBuilder<List<Budget>>(
      stream: Provider.of<DatabaseProvider>(context).getBudgetsByYear(2023),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Text("Error");
        }
        if(snapshot != null){
          if(snapshot.data != null){
            hasData = true;
          }
        }
        List<Budget> budgets = snapshot.data == null ? [] : snapshot.data!;

        return SafeArea(
          child: Scaffold(

            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: isDark?Color.fromRGBO(43, 40, 57, 1):Color.fromRGBO(200, 200, 255, 200),
                      image: DecorationImage(image: isDark?AssetImage("assets/images/background-cropped-dark.jpg"):AssetImage("assets/images/background-cropped.jpg"),fit: BoxFit.fill,opacity: 0.2)
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 5),
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                size: 35,
                                color: isDark?Colors.white:Colors.black,
                              )),
                        ),
                        Padding(
                          padding:language == 'en'?EdgeInsets.only(left: 60, bottom: 10):EdgeInsets.only(right: 60, bottom: 10),
                          child: Text(
                            "${translation(context).statistics}",
                            style: TextStyle(
                                color: isDark?Colors.white:Colors.black,
                                fontSize: 50,
                                fontFamily: 'K2D',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10,bottom: 40),
                            child: Text('${translation(context).statisticsQuote}',
                              style: TextStyle(
                                  color: isDark?Colors.white:Colors.black,
                                  fontSize: 23,
                                  fontFamily: 'K2D',
                                fontWeight: FontWeight.bold
                                  ),
                            ),
                          ),
                        ),

                        Center(child: statisticsPage(budgets)),
                      ]
                  )
              ),
            ),
          ),
        );
      }
    );
  }

  Widget statisticsPage(List<Budget> snapshot) {
    List<Budget> budgets = snapshot;
    Map<DateTime,List<Budget>> groupedBudgets = groupByMonth(budgets);
    print(groupedBudgets);
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: isDark?Color.fromRGBO(53, 50, 67, 100):Color.fromRGBO(245, 245, 245, 100),
              border: Border.all(color: Colors.grey,),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(60),topRight: Radius.circular(60),)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                      decoration: BoxDecoration(
                        color: isDark?Color.fromRGBO(43, 40, 57, 1):Color.fromRGBO(200, 200, 255, 200),
                        borderRadius: BorderRadius.circular(20),
                      ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${translation(context).totalExpenditure}",
                            style: TextStyle(
                              color: isDark?Colors.white:Colors.black,
                                fontSize: 20,
                                fontFamily: 'K2D',
                                fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 300,
                        //make height dynamic
                        height: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: stackedBarChart(budgets),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 360,
                height: 200,
                decoration: BoxDecoration(
                  color: isDark?Color.fromRGBO(43, 40, 57, 1):Color.fromRGBO(200, 200, 255, 200),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${translation(context).highestExpenditure}: ",style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'K2D',
                        color: isDark?Colors.white:Colors.black,
                        fontWeight: FontWeight.bold
                      ),),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(

                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [
                                  Text(
                                      "${getHighestTotalSpentBudget(budgets).name.toString()}",style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: 'K2D',
                                      color: isDark?Colors.white:Colors.black,
                                      fontWeight: FontWeight.bold
                                  )
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                        " , ${DateTime.now().year}/${DateFormat('MMMM').format(DateTime(0, getHighestTotalSpentBudget(budgets).budgetDate.toDate().month)).toString()}",style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'K2D',
                                        color: isDark?Colors.white:Colors.black,
                                        fontWeight: FontWeight.w400
                                    )
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                  "${translation(context).totalSpentStat}: ${getHighestTotalSpentBudget(budgets).totalSpent.toString()}",style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'K2D',
                                  color: isDark?Colors.white:Colors.black,
                                  fontWeight: FontWeight.w200
                              )
                              ),
                              Text(
                                  "${translation(context).budgetedAmount}: ${getHighestTotalSpentBudget(budgets).amount.toString()}",style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'K2D',
                                  color: isDark?Colors.white:Colors.black,
                                  fontWeight: FontWeight.w200
                              )
                              ),
                            ],

                          )
                          ]
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
  }
  Widget stackedBarChart(List<Budget> budgets) {


    List<Budget> budgetsList = budgets;
    double highestAmount = (getHighestAmount(budgetsList) / 200).ceil() * 200;
    double highestTotal = (highestTotalSpent(budgetsList) / 200).ceil() * 200;


    bool yValue = highestAmount > highestTotal;
    Map<DateTime,List<Budget>> groupedBudgets = groupByMonth(budgetsList);

    //x axis vals
    List<String> months = groupedBudgets.keys.map((e) => DateFormat('MMMM').format(DateTime(0, e.month)).toString()).toList();

    print(groupedBudgets);
    var groupedBudgetsWithAmounts = groupedBudgets.keys.map((e) => makeGroupData(e.month, getHighestAmount(groupedBudgets[e]!), highestTotalSpent(groupedBudgets[e]!)));

    return BarChart(
      BarChartData(
          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 55,
                interval: 200,
                getTitlesWidget: leftTitles
              ),
            ),
            rightTitles:  AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles:  AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: bottomTitles,
                  reservedSize: 42,
                ),
              ),
          ),
          maxY: yValue ? highestAmount : highestTotal,
        alignment: BarChartAlignment.spaceEvenly,

          gridData: FlGridData(show: true, drawHorizontalLine: true,drawVerticalLine: false),

          borderData: FlBorderData(
            show: false,
          ),
        //x values are the months in the Map above (groupedBudgets) or the keys
         barGroups: groupedBudgetsWithAmounts!.toList(),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: isDark?Color.fromRGBO(159, 79, 248, 1):Color(0xFF145756),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String weekDay;
                //rod is an object of type rod that returns all the attributes of a rod
                //rodIndex returns the number of the rod, in our case we have 0 (amount),1 (totalSpent)
                switch (rodIndex) {

                  case 0:
                    weekDay = 'amount';
                    break;
                  case 1:
                    weekDay = 'Total spent';
                    break;
                  default:
                    weekDay = "not found";
                }
                return BarTooltipItem(
                  '$weekDay\n',
                   TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: (rod.toY).toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }

          )
            ),
      ),

        swapAnimationDuration: Duration(milliseconds: 300), // Optional
        swapAnimationCurve: Curves.linear, // Optional
    );
  }

  //utility methods
  double getHighestAmount(List<Budget> budgets){
    double amount = 0.0;
    for(Budget budget in budgets){
      amount += budget.amount;
    }
    return amount;
  }
  double highestTotalSpent(List<Budget> budgets){
    double totalAmount = 0.0;
    for(Budget budget in budgets){
      totalAmount += double.parse(budget!.totalSpent.toString());
    }
    return totalAmount;
  }
  Map<DateTime,List<Budget>> groupByMonth(List<Budget> budgets){

    Map<DateTime,List<Budget>> groupedBudgets = {};
    for(Budget budget in budgets){
      DateTime date = budget.budgetDate.toDate();
      //print(date.month);
      if(groupedBudgets.containsKey(date)){
        groupedBudgets[date]!.add(budget);
      }else{
        groupedBudgets[date] = [budget];
      }
    }
    //we sort the map by the keys (months)
    groupedBudgets = Map.fromEntries(
        groupedBudgets.entries.toList()..sort(
                (e1, e2) => e1.key.compareTo(e2.key)
        )
    );

    return groupedBudgets;
  }
  Budget getHighestTotalSpentBudget(List<Budget> budgets){
    double max = 0.0;
    late Budget maxBudget;

    budgets..sort((e1, e2) => e1.totalSpent!.compareTo(e2!.totalSpent!));
    print(budgets[budgets.length - 1]);

    return budgets[budgets.length - 1];
  }

  //Bar chart data
  BarChartGroupData makeGroupData(int month, double y1, double y2){
    List<int> toolTips = [];
    return BarChartGroupData(
      barsSpace: 4,
      x: month,
      barRods: [
        BarChartRodData(toY: y1, color: isDark?Color.fromRGBO(200, 70, 200, 1):Color(0xFF34cfb3), width: 10, fromY: 0.0),
        BarChartRodData(toY: y2, color: isDark?Colors.deepPurple:Color(0xFF4B9EB8), width: 10, fromY: 0.0)
      ],
        showingTooltipIndicators: toolTips
    );
  }
  Widget bottomTitles(double value, TitleMeta meta) {

    final titles = <String>['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July','Aug', 'Sept', 'Oct', 'Nov', 'Dec'];
    final Widget text = Text(
      titles[value.toInt() - 1
      ],
      style: TextStyle(
        fontFamily: 'K2D',
        color: isDark?Colors.white:Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }
  Widget leftTitles(double value,TitleMeta meta){
    return SideTitleWidget(
        child: Text(
          value.toInt().toString(),
          style: TextStyle(
              color: isDark?Colors.white:Colors.black,
              fontFamily: 'K2D',fontSize: 15),
        ),
        axisSide: AxisSide.left
    );
  }

  //create a function that gets the total amount spent per month

}
