import 'package:flutter/material.dart';
import 'package:testapp/component/card_design.dart';
import 'package:testapp/component/right_drawer.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

int selectedMonthIndex=0;

class _BudgetPageState extends State<BudgetPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
      automaticallyImplyLeading: false,
      iconTheme: IconThemeData(color: Colors.blueGrey, size: 40),
      backgroundColor: Colors.white,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal:2.0),
        child: Text(
          "hello,UserName",
          style: TextStyle(
              color: Color.fromRGBO(102, 102, 102, 1),
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      ),
    ),

        //to add drawer on the right use (endDrawer)
        endDrawer: RightDrawer(),


        //Container
          body: Column(children: [
            Container(
              width: 500,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          " 1000 JD ",
                          style: TextStyle(
                              color: Color.fromRGBO(102, 102, 102, 1),

                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 40,
                      width: 190,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Color.fromRGBO(92, 102, 114, 1)),

                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                selectedMonthIndex = selectedMonthIndex == 0 ? 0 : selectedMonthIndex - 1;
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
                              '${months[selectedMonthIndex]}',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                selectedMonthIndex = selectedMonthIndex == 11 ? 11 : selectedMonthIndex + 1;
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

                  ),
                ],
              ),
            ),

            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return CardDesign();
                },
              ),
            ),

          ]
          ),
      ),
    );
  }
}