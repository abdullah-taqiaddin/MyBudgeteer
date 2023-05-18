import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'budget_page.dart';

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
        child: ListView.builder(
          itemCount: cardData.length,
          itemBuilder: (context, index) {
            final card = cardData[index];
            return ListTile(
              title: Text(card['type'] ?? ''),
              subtitle: Text(card['spent'] ?? ''),
            );
          },
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
