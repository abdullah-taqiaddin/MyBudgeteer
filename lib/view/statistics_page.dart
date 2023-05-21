import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'budget_page.dart';
import 'expense_page.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}


class _StatisticsPageState extends State<StatisticsPage> {
  // var budgetData = cardData;
  double _parseDouble(String value) {
    final cleanValue = value.replaceAll('\$', ''); // Remove dollar sign
    return double.tryParse(cleanValue) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(image: AssetImage("assets/images/background-cropped.jpg"),fit: BoxFit.fill,opacity: 0.5)
        ),



          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 100.0),
                child: Column(
                  children: [
                    Text(
                      'Top 5 Budgets',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF145756),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      padding: EdgeInsets.all(10.0),
                      height: MediaQuery.of(context).size.height / 3.4,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: cardData.length > 5 ? 5 : cardData.length,
                        itemBuilder: (context, index) {
                          final sortedBudgets = cardData
                              .where((card) => card['total'] != null)
                              .toList()
                            ..sort((a, b) => _parseDouble(b['total'] ?? '0')
                                .compareTo(_parseDouble(a['total'] ?? '0')));

                          final card = sortedBudgets[index];

                          final color = index % 2 == 0
                              ? Color.fromRGBO(34, 165, 162, 1)
                              : Color.fromRGBO(59, 202, 163, 1);

                          return Container(
                            margin: EdgeInsets.only(bottom: 8.0),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ListTile(
                              title: Text(
                                card['type'] ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                '\$${card['total'] ?? ''}'.replaceAll('\$', ''),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.0),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      'Top 5 Expenses',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF145756),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      height: MediaQuery.of(context).size.height / 3.4,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: cardData.length > 5 ? 5 : cardData.length,
                        itemBuilder: (context, index) {
                          final sortedExpenses = cardData
                              .where((card) => card['spent'] != null)
                              .toList()
                            ..sort((a, b) => _parseDouble(b['spent'] ?? '0')
                                .compareTo(_parseDouble(a['spent'] ?? '0')));

                          final anotherCard = sortedExpenses[index];

                          final color = index % 2 == 0
                              ? Color.fromRGBO(34, 165, 162, 1)
                              : Color.fromRGBO(59, 202, 163, 1);

                          return Container(
                            margin: EdgeInsets.only(bottom: 8.0),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ListTile(
                              title: Text(
                                anotherCard['type'] ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                '\$${anotherCard['spent'] ?? ''}'.replaceAll('\$', ''),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )







      ),
    );
  }
}


// class _StatisticsPageState extends State<StatisticsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.maxFinite,
//         decoration: BoxDecoration(
//             color: Colors.white,
//             image: DecorationImage(image: AssetImage("assets/images/background-cropped.jpg"),fit: BoxFit.fill,opacity: 0.5)
//         ),
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 50, left: 20),
//                 child: IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: Icon(
//                       Icons.arrow_back,
//                       size: 40,
//                     )),
//               ),
//
//               Opacity(
//                 opacity: 0.5,
//                 child: Center(
//                   child: Lottie.network("https://assets9.lottiefiles.com/packages/lf20_22mjkcbb.json"),
//                 ),
//               )
//
//             ]),
//
//       ),
//     );
//
//   }
// }
