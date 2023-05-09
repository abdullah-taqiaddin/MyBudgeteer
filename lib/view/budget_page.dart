// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/component/forms/expense_form.dart';

import 'package:testapp/component/right_drawer.dart';
import 'package:testapp/model/budget.dart';
import 'package:testapp/view/expense_page.dart';
import 'package:testapp/viewmodel/database_provider.dart';
import '../component/forms/budget_form.dart';
import '../viewmodel/auth_provider.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}


bool noData = false;

final List<Map<String, String>> cardData = [
  {
    'type': 'Food',
    'spent': '\$25.00',
    'total': '\$100.00',
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
    final user = Provider.of<AuthProvider>(context).user;
    final dbProvider = DatabaseProvider(uid: user!.uid);

    TabController _tabController = TabController(length: 2, vsync: this);

    return StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
      stream: dbProvider.GetBudgets().snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          noData = true;
        }
        if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
        }
        return Scaffold(
          extendBody: true,
          bottomNavigationBar: Container(
            //Bottom app bar
            child: BottomAppBar(
              shape: AutomaticNotchedShape(RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50), topLeft: Radius.circular(50)),
              )),

              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromRGBO(59, 202, 163, 1),
                        Color.fromRGBO(34, 165, 162, 1),
                      ]),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50),
                  ),
                ),
                height: 50,
              ),
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
          Material(
              elevation: 4,
              shape: CircleBorder(),
              color: Color(0XFFFF6B35),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(50),
                      ),
                    ),
                    context: context,
                    builder: (BuildContext context) => Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: evalTabForm(_tabController, dbProvider),
                    ),
                  );
                },
                child: Container(
                  width: 70,
                  height: 70,
                  child: Icon(Icons.add, size: 35, color: Colors.white),
                ),
              ),
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

        body: MainBody(_tabController,user, snapshot),
        );
      }
    );
  }

  Widget MainBody(TabController controller, User? user, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    final String? photoUrl = user?.photoURL;

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
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(photoUrl ?? ""),
                    radius: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Hello, ${(user?.displayName) == null ? "guest!" : user?.displayName}",
                    style: TextStyle(
                      fontFamily: "K2D",
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: Container(

                //******** container decoration ********
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/images/background-cropped-2.jpg"),
                        fit: BoxFit.fill,
                        opacity: 0.3),
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
                          Tab(child: budgetTab(snapshot)),
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

  Widget buildBudgetCard(Color color, String type, String spent, String total) {
    return Container(
      width: 150,
      height: 170,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(20),
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
                Text(
                  "$remaining \$",
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
                Text(
                  "\-$spent \$",
                  style: TextStyle(
                      fontFamily: "K2D",
                      fontSize: 16,
                      color: Color(0XFF145756),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Total",
                  style: TextStyle(
                      fontFamily: "K2D",
                      fontSize: 18,
                      color: Color(0XFF145756),
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "\+$total \$",
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

  Widget budgetTab( AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot ) {


    Color lastColor = Color(0xFF34cfb3);
    Color firstColor = Color(0xFF34cfb3);
    Color secondColor = Color(0xFF4B9EB8);
    List<QueryDocumentSnapshot<Map<String, dynamic>>> budgets = snapshot.data!.docs;

    if(budgets.isEmpty){
      return noFoundBudget();
    }

    return Column(
      children: [
        MainBudgetInfo("2100", "100", "4000"),
        SizedBox(
          height: 0.5,
        ),
        Container(
          width: 330,
          height: 400,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 2),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: budgets.length,
            itemBuilder: (BuildContext context, int index) {
              return buildBudgetCard(
                Colors.blue.shade200,
                budgets[index]['name'],
                budgets[index]['amount'].toString(),
                budgets[index]['amount'].toString(),
              );
            },
          ),
          /*child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: budgets.length,
            itemBuilder: (BuildContext context, int index) {
              print("----" + index.toString());
              Widget firstCard = buildBudgetCard(
                Colors.blue.shade200,
                budgets[index]['name'],
                budgets[index]['amount'].toString(),
                budgets[index]['amount'].toString(),
              );
              Widget secondCard = SizedBox();
              if (index + 1 < budgets.length) {
                secondCard = buildBudgetCard(
                  Colors.blue.shade200,
                  budgets[index + 1]['name'],
                  budgets[index + 1]['amount'].toString(),
                  budgets[index + 1]['amount'].toString(),
                );
                index += 1;
                print(index);
              }

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
          ),*/


          /*child: ListView.builder(


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
                  ? buildBudgetCard(
                      firstCardColor,
                      cardData[firstCardIndex]['type']!,
                      cardData[firstCardIndex]['spent']!,
                      cardData[firstCardIndex]['total']!,
                    )
                  : SizedBox();

              final Widget secondCard = (secondCardIndex < cardData.length)
                  ? buildBudgetCard(
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
          ),*/
        ),
      ],
    );
  }


  Future<dynamic> getUserInfo(String uid) async {
    var document = FirebaseFirestore.instance.collection('users').doc(uid);
    DocumentSnapshot snapshot = await document.get();
    return snapshot.data();
  }

  Widget noFoundBudget(){
    return Stack(
        clipBehavior: Clip.none, alignment: Alignment.topCenter,
        children: [
          Positioned(
              top: 150.0,

              child: Text("No Budgets?\nAdd up!", style: TextStyle(fontSize: 40.0,
                fontFamily: "K2D",),)
          )
        ]
    );
  }


  //TODO:move to components

  Widget evalTabForm(TabController controller, DatabaseProvider provider) {
    switch (controller.index) {
      case 0:
        return BudgetForm(dbProvider: provider,);
        break;
      case 1:
        return ExpenseForm();
        break;
      default:
        return BudgetForm(dbProvider: provider,);
    }
  }
}

