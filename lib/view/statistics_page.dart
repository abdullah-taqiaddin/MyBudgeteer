
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:testapp/view/budget_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:testapp/component/delete_alert.dart';
import 'package:testapp/component/forms/expense_form.dart';

import 'package:testapp/component/right_drawer.dart';
import 'package:testapp/model/budget.dart';
import 'package:testapp/view/expense_page.dart';
import 'package:testapp/viewmodel/database_provider.dart';
import '../component/forms/budget_form.dart';
import '../viewmodel/auth_provider.dart';

import 'package:testapp/viewmodel/localization.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}



class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}
int currentMonthIndex = DateTime.now().month + 1 ;
String _selectedYear = DateFormat.y().format(DateTime.now()).toString();
class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [

            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      image: AssetImage("assets/images/background-cropped.jpg"),
                      fit: BoxFit.fill,
                      opacity: 0.5)
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50, left: 20),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 40,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Center(
                          child: Opacity(
                            opacity: 0.7,
                            child: Container(
                              margin: EdgeInsets.all(16.0),
                              child: Text(
                                "Trouble managing your spending's? \n"
                                    "We got you covered!\n",
                                style: TextStyle(
                                    fontSize: 40,
                                    color: Colors.black,
                                    fontFamily: 'K2D'),

                              ),
                            ),
                          )
                      ),
                    ),
                    SizedBox(height: 10,),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        //******** container decoration ********
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey,
                                  width: 2
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(35),
                                topRight: Radius.circular(35),
                              )),
                          child: Column(
                            children: [
                              SizedBox(height: 10,),
                              monthSliderYearDropdown(),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.info),
                                    iconSize: 30.0,
                                    color: Color(0XFFFF6B35),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Card(
                                      shadowColor: Color(0xFF34cfb3),
                                      elevation: 10.0,
                                      child: SfCartesianChart(

                                        primaryXAxis: CategoryAxis(),
                                        // Chart title
                                        title: ChartTitle(
                                            text: 'Total Vs. Spent'),


                                        series: <
                                            ColumnSeries<SalesData, String>>[
                                          ColumnSeries<SalesData, String>(
                                              color: Colors.greenAccent,

                                              sortingOrder: SortingOrder
                                                  .ascending,
                                              width: 0.4,
                                              dataSource: <SalesData>[
                                                SalesData('Total', 500),
                                              ],
                                              xValueMapper: (SalesData sales,
                                                  _) => sales.year,
                                              yValueMapper: (SalesData sales,
                                                  _) => sales.sales,
                                              dataLabelSettings: DataLabelSettings(
                                                labelAlignment: ChartDataLabelAlignment
                                                    .outer,
                                                isVisible: true,
                                                angle: 90,)
                                          ),
                                          ColumnSeries<SalesData, String>(
                                              color: Colors.redAccent,
                                              sortingOrder: SortingOrder
                                                  .ascending,
                                              width: 0.4,
                                              dataSource: <SalesData>[
                                                SalesData('Spent', 280),
                                              ],
                                              xValueMapper: (SalesData sales,
                                                  _) => sales.year,
                                              yValueMapper: (SalesData sales,
                                                  _) => sales.sales,
                                              dataLabelSettings: DataLabelSettings(
                                                labelAlignment: ChartDataLabelAlignment
                                                    .outer,
                                                isVisible: true,
                                                angle: 90,)
                                          )
                                        ],

                                      ),
                                    )
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.info),
                                    iconSize: 30.0,
                                    color: Color(0XFFFF6B35),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Card(
                                      shadowColor: Color(0xFF34cfb3),
                                      elevation: 10.0,
                                      child: SfCircularChart(
                                          title: ChartTitle(text: 'Categories'),
                                          series: <CircularSeries<SalesData,
                                              String>>[
                                            DoughnutSeries<SalesData, String>(
                                                sortingOrder: SortingOrder
                                                    .ascending,
                                                dataSource: <SalesData>[
                                                  SalesData('Total', 500),
                                                  SalesData('Spent', 280),
                                                  SalesData('Spent', 280),

                                                ],
                                                xValueMapper: (SalesData sales,
                                                    _) => sales.year,
                                                yValueMapper: (SalesData sales,
                                                    _) => sales.sales,
                                                dataLabelSettings: DataLabelSettings(
                                                  labelAlignment: ChartDataLabelAlignment
                                                      .outer,
                                                  isVisible: true,
                                                ),
                                                enableTooltip: true
                                            )
                                          ]
                                      ),
                                    )
                                ),
                              ),
                              SizedBox(height: 15,)


                            ],
                          )),
                    ),
                  ]),

            ),

          ],
        ),
      ),
    );
  }

  Widget monthSliderYearDropdown(){
    return Row(
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
    );
  }

}