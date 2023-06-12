import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:testapp/model/budget.dart';
import 'package:testapp/view/budget_page.dart';
import 'package:testapp/viewmodel/database_provider.dart';
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

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 100,
             backgroundColor: Color(0x00000000),
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.only(left: 16.0,top: 30),
              child: Text(
                "statistics",
                style: TextStyle(
                  color: Colors.black,
                    fontSize: 35,
                    fontFamily: 'K2D',
                    fontWeight: FontWeight.bold),
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 16.0,top: 30),
              child: new IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  size: 40,
                ),
                onPressed: () => Navigator.of(context).pop(),
                color: Colors.black,
              ),
            ),
          ),
          body: Center(
            child: StatisticsPage(budgets),
          ),
        );
      }
    );
  }
  Widget StatisticsPage(List<Budget> snapshot) {
    List<Budget> budgets = snapshot;
    Map<DateTime,List<Budget>> groupedBudgets = groupByMonth(budgets);
    print(groupedBudgets);
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
          ),

          Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF145756),
                    borderRadius: BorderRadius.circular(20),
                  ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(

                        "Total expenditure per year",
                        style: TextStyle(
                          color: isDark?Colors.black:Colors.white,
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
        ],
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

    //var barChartsData = groupedBudgets.map((key, value) => makeGroupData(DateFormat('MMMM').format(DateTime(0, key.month).month, ), y1, y2))
    print(groupedBudgets);
    var groupedBudgetsWithAmounts = groupedBudgets.keys.map((e) => makeGroupData(e.month, getHighestAmount(groupedBudgets[e]!), highestTotalSpent(groupedBudgets[e]!)));

    return BarChart(

      BarChartData(


          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
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
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String weekDay;
                print("group x values${rodIndex}");
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
                  const TextStyle(
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

  BarChartGroupData makeGroupData(int month, double y1, double y2){
    List<int> toolTips = [];
    return BarChartGroupData(
      barsSpace: 4,
      x: month,
      barRods: [
        BarChartRodData(toY: y1, color: Color(0xFF34cfb3), width: 10, fromY: 0.0),
        BarChartRodData(toY: y2, color: Color(0xFF4B9EB8), width: 10, fromY: 0.0)
      ],
        showingTooltipIndicators: toolTips
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {

    final titles = <String>['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July','Aug', 'Sept', 'Oct', 'Nov', 'Dec'];
    final Widget text = Text(
      titles[value.toInt() - 1
      ],
      style: const TextStyle(
        fontFamily: 'K2D',
        color: Colors.white,
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
        child: Text(value.toInt().toString(),style: TextStyle(color: Colors.white, fontFamily: 'K2D',fontSize: 15),), axisSide: AxisSide.left
    );
  }

  List<int> generateList(int value) {
    List<int> result = [];
    for (int i = 200; i <= value; i += 200) {
      result.add(i);
    }
    return result;
  }

  //create a function that gets the total amount spent per month

}
