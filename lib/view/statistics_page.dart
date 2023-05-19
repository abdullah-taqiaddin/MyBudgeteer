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
                      'Top 5 budgets',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 3.5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: cardData.length,
                        itemBuilder: (context, index) {
                          final card = cardData[index];
                          return ListTile(
                            title: Text(card['type'] ?? ''),
                            subtitle: Text(card['total'] ?? ''),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50.0), // Add space of 50.0 between the boxes
              Container(
                child: Column(
                  children: [
                    Text(
                      'Top 5 expenses',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 3.5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: cardData.length,
                        itemBuilder: (context, index) {
                          final anotherCard = cardData[index];
                          return ListTile(
                            title: Text(anotherCard['type'] ?? ''),
                            subtitle: Text(anotherCard['spent'] ?? ''),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),






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
