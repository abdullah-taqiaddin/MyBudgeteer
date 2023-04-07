// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'package:testapp/component/bottom_container.dart';
//import 'package:testapp/component/card_design.dart';
import 'package:testapp/component/right_drawer.dart';

import '../viewmodel/auth_provider.dart';

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

int selectedMonthIndex = 0;
int MonthIndex = 0;

// Expenses Colors Cards
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
   // Color.fromRGBO(0, 78, 137, 1),
    //Color.fromRGBO(26, 101, 158, 1),
    Color.fromRGBO(75, 158, 184, 1),
    Color.fromRGBO(101, 129, 168, 1),
    //Color.fromRGBO(180, 210, 237, 1),
  ],
);

final List<Map<String, String>> cardData = [
  {
    'type': 'Food',
    'spent': '\$25.00',
    'total': '\$100.00',
  },
  {
    'type': 'Shopping',
    'spent': '\$50.00',
    'total': '\$200.00',
  },
  {
    'type': 'transport',
    'spent': '\$20.00',
    'total': '\$50.00',
  },
  {
    'type': 'Food',
    'spent': '\$25.00',
    'total': '\$100.00',
  },
  {
    'type': 'Shopping',
    'spent': '\$50.00',
    'total': '\$200.00',
  },
  {
    'type': 'transport',
    'spent': '\$20.00',
    'total': '\$50.00',
  },
  {
    'type': 'Food',
    'spent': '\$25.00',
    'total': '\$100.00',
  },
  {
    'type': 'Shopping',
    'spent': '\$50.00',
    'total': '\$200.00',
  },
  {
    'type': 'transport',
    'spent': '\$20.00',
    'total': '\$50.00',
  },
  {
    'type': 'Food',
    'spent': '\$25.00',
    'total': '\$100.00',
  },
  {
    'type': 'Shopping',
    'spent': '\$50.00',
    'total': '\$200.00',
  },
  {
    'type': 'transport',
    'spent': '\$20.00',
    'total': '\$50.00',
  },
];

int TextPrimary = 0XFF145756;

class _BudgetPageState extends State<BudgetPage> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userCredential = Provider.of<AuthProvider>(context).userCredential;
    TabController _tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        child: BottomAppBar(
          shape: AutomaticNotchedShape(RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(50), topLeft: Radius.circular(50)),
          )),
          //color: Color(0XFF2DB79E),
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color.fromRGBO(59, 202, 163, 1),
                    Color.fromRGBO(34, 165, 162, 1),
                  ]),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50), topLeft: Radius.circular(50)),
            ),
            height: 60,
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingActionButton.large(
          onPressed: () {
            //TODO:OPEN A DIALOG BOX
            Map<String, String> newBudget = {
              'type': 'budgetType',
              'spent': 'amountSpent',
              'total': 'totalBudget',
            };

            setState(() {
              cardData.add(newBudget);
            });
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0XFFFF6B35),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      endDrawer: RightDrawer(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
            Navigator.pop(context);
          });
        },
      ),
      body: MainBody(_tabController, userCredential),
    );
  }

  /*
    /Main body widget takes two params, tabcontroller, user creds
     */

  Widget MainBody(TabController controller, UserCredential? userCredential) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(color: Color(0XFF2DB79E)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          AppBar(
            actions: [
              Builder(
                builder: (context) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: 35,
                    ),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
                ),
              ),
            ],
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                "Hello, ${userCredential?.user?.displayName}",
                style: TextStyle(fontFamily: "K2D", fontSize: 23),
              ),
            ),
          ),
          Flexible(
            child: Container(

                //******** container decoration ********
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage("assets/images/background-cropped.jpg"),
                        fit: BoxFit.fill,
                        opacity: 0.5),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    )),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.grey, width: 0.8))),
                      child: TabBar(
                        labelColor: Color(TextPrimary),
                        unselectedLabelColor: Colors.grey,
                        indicator: UnderlineTabIndicator(
                          borderSide:
                              BorderSide(width: 2.0, color: Color(0XFF145756)),
                          insets: EdgeInsets.symmetric(horizontal: 50.0),
                        ),
                        controller: controller,
                        tabs: [
                          Tab(
                            child: Text(
                              "Budget",
                              style: TextStyle(
                                  fontFamily: "K2D",
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Expense",
                              style: TextStyle(
                                  fontFamily: "K2D",
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: controller,
                        children: [
                          Tab(child: budgetTab()),
                          Tab(child: expenseTab()),
                        ],
                      ),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  //Budget

  Widget buildCard(Color color, String type, String spent, String total) {
    return Container(
      width: 150,
      height: 160,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type,
            style: TextStyle(
                fontFamily: "K2D",
                fontSize: (type.length) > 9 ? 17 : 25,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(height: 20),
          Text(
            spent,
            style: TextStyle(
                fontFamily: "K2D",
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Text(
            "of $total",
            style:
                TextStyle(fontFamily: "K2D", fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget MainBudgetInfo(String remaining, String spent, String total) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "remaining",
                  style: TextStyle(
                      fontFamily: "K2D",
                      fontSize: 22,
                      color: Color(0XFF145756),
                      fontWeight: FontWeight.bold),
                ),
                Text("$remaining \$",
                  style: TextStyle(
                      fontFamily: "K2D",
                      fontSize: 50,
                      color: Color(0XFF145756),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(width: 30),
            Column(
              children: [
                Text(
                  "Spent",
                  style: TextStyle(
                      fontFamily: "K2D",
                      fontSize: 18,
                      color: Color(0XFF145756),
                      fontWeight: FontWeight.bold),
                ),
                Text("\-$spent \$",
                  style: TextStyle(
                      fontFamily: "K2D",
                      fontSize: 16,
                      color: Color(0XFF145756),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10,),
                Text("Total",
                  style: TextStyle(
                      fontFamily: "K2D",
                      fontSize: 18,
                      color: Color(0XFF145756),
                      fontWeight: FontWeight.bold),
                ),
                Text("\+$total \$",
                  style: TextStyle(
                      fontFamily: "K2D",
                      fontSize: 16,
                      color: Color(0XFF145756),
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget budgetTab() {
    Color lastColor = Color(0xFF34cfb3);

    Color firstColor = Color(0xFF34cfb3);
    Color secondColor = Color(0xFF4B9EB8);
    return Column(
      children: [
        MainBudgetInfo("2100", "100", "4000"),
        SizedBox(
          height: 1,
        ),
        Container(
          width: 330,
          height: 380,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            //cardData is for testing purposes only, itll be a firebase request and mapping from JSON
            itemCount: (cardData.length / 2).ceil(),
            itemBuilder: (BuildContext context, int index) {
              final int firstCardIndex = index * 2;
              final int secondCardIndex = index * 2 + 1;

              /*
                * when index is 0, set the colors as is and set lastcolor to secondCardColor for comparison,
                * next time it checks last color if its the secondCardColor,it switches, and so on
                * */
              //TODO:LOOK FOR A WAY TO KEEP COLORS CONTSTANT,FLUTTER KEEPS CHANING COLORS CUZ IT BUILDS THE LIST DYNAMICALLY

              Color firstCardColor, secondCardColor;

              if (index == 0) {
                //start off the coloring
                firstCardColor = secondColor;
                secondCardColor = firstColor;
              } else {
                if (lastColor == firstColor) {
                  firstCardColor = firstColor;
                  secondCardColor = secondColor;
                } else {
                  firstCardColor = secondColor;
                  secondCardColor = firstColor;
                }
              }

              lastColor = secondCardColor;

              final Widget firstCard = (firstCardIndex < cardData.length)
                  ? buildCard(
                      firstCardColor,
                      cardData[firstCardIndex]['type']!,
                      cardData[firstCardIndex]['spent']!,
                      cardData[firstCardIndex]['total']!,
                    )
                  : SizedBox();

              final Widget secondCard = (secondCardIndex < cardData.length)
                  ? buildCard(
                      secondCardColor,
                      cardData[secondCardIndex]['type']!,
                      cardData[secondCardIndex]['spent']!,
                      cardData[secondCardIndex]['total']!,
                    )
                  : SizedBox();

              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(child: firstCard),
                    SizedBox(width: 20),
                    Expanded(child: secondCard),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddBudgetDialog(BuildContext context) {
    TextEditingController typeController = TextEditingController();
    TextEditingController spentController = TextEditingController();
    TextEditingController totalController = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add New Budget'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(hintText: 'Budget Type'),
                ),
                TextField(
                  controller: spentController,
                  decoration: InputDecoration(hintText: 'Amount Spent'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: totalController,
                  decoration: InputDecoration(hintText: 'Total Budget'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Add'),
                onPressed: () {
                  String budgetType = typeController.text;
                  double amountSpent = double.parse(spentController.text);
                  double totalBudget = double.parse(totalController.text);
                  Map<String, String> newBudget = {
                    'type': budgetType,
                    'spent': amountSpent.toString(),
                    'total': totalBudget.toString(),
                  };

                  setState(() {
                    cardData.add(newBudget);
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  //Expense
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
                borderRadius: BorderRadius.circular(40),
                gradient:gradient
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                dateTime.year.toString(),
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

  Widget expenseTab() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Months
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Container(
                  height: 40,
                  width: 190,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.teal[200],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            MonthIndex = MonthIndex == 0 ? 0 : MonthIndex - 1;
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
                          '${months[MonthIndex]}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            MonthIndex = MonthIndex == 11 ? 11 : MonthIndex + 1;
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
          SizedBox(
            width: 5,
          ),
          //Years
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Container(
                  height: 40,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color.fromRGBO(123, 203, 201, 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Years',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
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

              final Widget ExpenseCard1 = buildExpenseCard(
                  gradient1, DateTime(2023), "Food", "100", "KFC");
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

/*
  COMMENTED CODE
   */

// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:testapp/component/bottom_container.dart';
// import 'package:testapp/component/card_design.dart';
// import 'package:testapp/component/right_drawer.dart';
//
// import '../viewmodel/auth_provider.dart';
//
// class BudgetPage extends StatefulWidget {
//   const BudgetPage({Key? key}) : super(key: key);
//
//   @override
//   State<BudgetPage> createState() => _BudgetPageState();
// }
//
// List<String> months = [
//   'January',
//   'February',
//   'March',
//   'April',
//   'May',
//   'June',
//   'July',
//   'August',
//   'September',
//   'October',
//   'November',
//   'December'
// ];
//
// int selectedMonthIndex=0;
//
// class _BudgetPageState extends State<BudgetPage> {
//   int _selectedIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     final userCredential = Provider.of<AuthProvider>(context).userCredential;
//     return Scaffold(
//       body: SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.blueGrey[100],
//         appBar: AppBar(
//         automaticallyImplyLeading: false,
//         iconTheme: IconThemeData(color: Colors.blueGrey, size: 40),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Padding(
//           padding: const EdgeInsets.symmetric(horizontal:2.0),
//           child: Text(
//             "hello,${userCredential?.user?.displayName}",
//             style: TextStyle(
//                 color: Color.fromRGBO(102, 102, 102, 1),
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//
//           //to add drawer on the right use (endDrawer)
//           endDrawer: RightDrawer(
//             selectedIndex: _selectedIndex,
//             onItemTapped: (index) {
//               setState(() {
//                 _selectedIndex = index;
//                 Navigator.pop(context);
//               });
//             },
//           ),
//
//
//           //Container
//             body: Column(children: [
//               Container(
//                 width: 500,
//                 height: 110,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(50),
//                     bottomRight: Radius.circular(50),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: Offset(0, 3), // changes position of shadow
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 10),
//                       child: Row(
//                         children: [
//                           Text(
//                             " 1000 JD ",
//                             style: TextStyle(
//                                 color: Color.fromRGBO(102, 102, 102, 1),
//
//                                 fontSize: 40,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Center(
//                       child: Container(
//                         height: 40,
//                         width: 190,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16),
//                             color: Color.fromRGBO(92, 102, 114, 1)),
//
//                         child:
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   selectedMonthIndex = selectedMonthIndex == 0 ? 0 : selectedMonthIndex - 1;
//                                 });
//                               },
//                               icon: Icon(
//                                 Icons.chevron_left,
//                                 color: Colors.white,
//                                 size: 30,
//                               ),
//                             ),
//                             Center(
//                               child: Text(
//                                 '${months[selectedMonthIndex]}',
//                                 style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white),
//                               ),
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   selectedMonthIndex = selectedMonthIndex == 11 ? 11 : selectedMonthIndex + 1;
//                                 });
//                               },
//                               icon: Icon(
//                                 Icons.chevron_right,
//                                 color: Colors.white,
//                                 size: 30,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                     ),
//                   ],
//                 ),
//               ),
//
//               SizedBox(
//                 height: 20,
//               ),
//
//               // Budget UI
//
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: 10,
//                   itemBuilder: (context, index) {
//                     return CardDesign();
//                   },
//                 ),
//               ),
//
//               // Container to add new Budget or Expense
//               //on tab user can Navigate between pages
//               Center(
//                   child:BottomContainer(color:Colors.white,)
//               ),
//
//             ]
//             ),
//         ),
//       ),
//     );
//   }
// }
