import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MyChart extends StatelessWidget {
  final List<SpendingData> data;

  MyChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
      child: Container(
        height: 260,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(90),
        ),
        child: charts.BarChart(

          _createSeries(),
          animate: true,
          domainAxis: charts.OrdinalAxisSpec(
            renderSpec: charts.SmallTickRendererSpec(
              labelStyle: charts.TextStyleSpec(
                fontSize: 4,
              ),
            ),
          ),
          primaryMeasureAxis: charts.NumericAxisSpec(
            renderSpec: charts.GridlineRendererSpec(
              labelStyle: charts.TextStyleSpec(
                fontSize: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<charts.Series<SpendingData, String>> _createSeries() {
    return [
      charts.Series<SpendingData, String>(
        id: 'Spending',
        domainFn: (SpendingData data, _) => data.month,
        measureFn: (SpendingData data, _) => data.totalSpent,
        colorFn: (SpendingData data, _) {
          if (data.totalSpent > data.budget) {
            return charts.MaterialPalette.red.shadeDefault;
          } else {
            return charts.MaterialPalette.green.shadeDefault;
          }
        },
        data: data,
      ),
    ];
  }
}

class SpendingData {
  final String month;
  final double totalSpent;
  final double budget;

  SpendingData({
    required this.month,
    required this.totalSpent,
    required this.budget,
  });
}

