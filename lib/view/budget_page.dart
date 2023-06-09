// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:testapp/component/delete_alert.dart';
import 'package:testapp/component/forms/expense_form.dart';

import 'package:testapp/component/right_drawer.dart';
import 'package:testapp/model/budget.dart';
import 'package:testapp/view/expense_page.dart';
import 'package:testapp/viewmodel/database_provider.dart';
import 'package:testapp/viewmodel/date_provider.dart';
import '../component/forms/budget_form.dart';
import '../viewmodel/auth_provider.dart';

import 'package:testapp/viewmodel/localization.dart';

import '../viewmodel/theme_provider.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

int TextPrimary = 0XFF145756;

bool isDark = false;
int currentMonthIndex = DateTime.now().month + 1 ;
String _selectedYear = DateFormat.y().format(DateTime.now()).toString();
bool doOnce = false;

class _BudgetPageState extends State<BudgetPage> with TickerProviderStateMixin {


  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedYear = DateFormat.y().format(DateTime.now()).toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider
        .of<AuthProvider>(context)
        .user;
    Provider
        .of<DatabaseProvider>(context)
        .uid = user!.uid;
    isDark = Provider.of<ThemeProvider>(context,listen: false).getTheme;


    TabController _tabController = TabController(length: 2, vsync: this);

    return StreamBuilder<QuerySnapshot>(
        stream: Provider.of<DatabaseProvider>(context).getBudgetsByMonth(currentMonthIndex+1, 2023),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            if(doOnce != true) {
              doOnce = true;
              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: Center(

                  child: CircularProgressIndicator(),
                ),
              );

            }
          }
          return Builder(
              builder: (context) {
                return Scaffold(
                  resizeToAvoidBottomInset: false,
                  extendBody: true,
                  bottomNavigationBar: Container(
                    //Bottom app bar
                    child: BottomAppBar(
                      shape: AutomaticNotchedShape(RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50), topLeft: Radius
                            .circular(50)),
                      )),

                      elevation: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.topRight,
                              colors: [
                                isDark?Color.fromRGBO(200, 79, 248, 50):Color.fromRGBO(34, 165, 162, 1),
                                isDark?Color.fromRGBO(159, 79, 248, 1):Color.fromRGBO(59, 202, 163, 1),
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
                      color: isDark?Color.fromRGBO(159, 79, 248, 1):Color(0XFFFF6B35),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(

                            isDismissible: true,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(50),
                              ),
                            ),
                            context: context,
                            builder: (context) =>
                                Padding(
                                  padding: MediaQuery
                                      .of(context)
                                      .viewInsets,
                                  child: evalTabForm(_tabController, Provider.of<DatabaseProvider>(context), context),
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
                  floatingActionButtonLocation: FloatingActionButtonLocation
                      .centerDocked,
                  endDrawer: RightDrawer(
                    selectedIndex: _selectedIndex,
                    onItemTapped: (index) {
                      setState(() {
                        _selectedIndex = index;
                        Navigator.pop(context);
                      });
                    },
                  ),

                  body: MainBody(_tabController, user, snapshot),
                );
              }
          );
        }
    );
  }

  Widget MainBody(TabController controller, User? user,
      AsyncSnapshot<QuerySnapshot> snapshot) {
    final String? photoUrl = user?.photoURL;

    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                isDark?Color.fromRGBO(200, 79, 248, 50):Color.fromRGBO(34, 165, 162, 1),
                isDark?Color.fromRGBO(159, 79, 248, 25):Color.fromRGBO(59, 202, 163, 1),
              ]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          AppBar(
            actions: [
              Builder(
                builder: (context) =>
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        icon: Icon(
                          Icons.menu,
                          size: 35,
                        ),
                        onPressed: () => Scaffold.of(context).openEndDrawer(),
                        tooltip:
                        MaterialLocalizations
                            .of(context)
                            .openAppDrawerTooltip,
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
                    "${translation(context).hello}, ${(user?.displayName) == null ? "guest!" : user
                        ?.displayName}",
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
                    border: Border.all(
                      color:isDark?Colors.deepPurple:Colors.grey,
                    ),
                    color: isDark?Color.fromRGBO(43, 40, 57, 1):Colors.white,
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
                              BorderSide(color:Colors.grey, width: 0.8))),
                      child: TabBar(
                        labelColor: isDark?Color.fromRGBO(216, 129, 255, 1):Color(TextPrimary),
                        unselectedLabelColor: Colors.grey,
                        indicator: UnderlineTabIndicator(
                          borderSide:
                          BorderSide(width: 2.0, color: isDark?Color.fromRGBO(216, 129, 255, 1):Color(0XFF145756)),
                          insets: EdgeInsets.symmetric(horizontal: 50.0),
                        ),
                        controller: controller,
                        tabs: [
                          Tab(
                            child: Text(
                              "${translation(context).budget}",
                              style: TextStyle(
                                  fontFamily: "K2D",
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "${translation(context).expense}",
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
                          Tab(child: ExpenseTab()),
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

  Widget buildBudgetCard(Color color, String type, String spent, String total,
      Budget? budget) {
    var lessThanAmount = (budget!.amount - budget.totalSpent!) < 0;
    var remaining = budget.amount - budget.totalSpent!;

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            type,
            style: TextStyle(
                fontFamily: "K2D",
                fontSize: (type.length) > 9 ? 17 : 25,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Text(
                "${budget!.totalSpent.toString()}",
                style: TextStyle(
                    fontFamily: "K2D",
                    fontSize: 16,
                    color: lessThanAmount? Colors.yellow  : Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 5),
              Text(
                  "${translation(context).spent}",
                style: TextStyle(
                fontFamily: "K2D",
                fontSize: 16,
                color: lessThanAmount? Colors.yellow : Colors.white,
                fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            "${translation(context).outOf} $total",
            style:
            TextStyle(fontFamily: "K2D", fontSize: 16, color: Colors.white),
          ),
          SizedBox(height: 20,),
          Container(
            color: Colors.white,
            height: 1.5,
          )
          , Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(50),
                        ),
                      ),
                      context: context,
                      builder: (BuildContext context) =>
                          Padding(
                            padding: MediaQuery
                                .of(context)
                                .viewInsets,
                            child: BudgetForm(initialBudget: budget,),
                          ),
                    );
                  },
                  icon: Icon(
                    Icons.edit, size: 30, color: Colors.white, weight: 10,),
                ),
                SizedBox(width: 15,),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DeletePopup(id: budget.id, name: budget.name,);
                          });
                    },
                    icon: Icon(Icons.delete, size: 30, color: Colors.white,)
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget budgetTab(AsyncSnapshot<QuerySnapshot> snapshot) {

    Color firstColor = isDark?Color.fromRGBO(200, 70, 200, 1):Color(0xFF34cfb3);
    Color secondColor = isDark?Colors.deepPurple:Color(0xFF4B9EB8);
    Color condition = isDark?Color.fromRGBO(200, 70, 200, 1):Color(0xFF34cfb3);
    int rowFinished = 0;

    List<QueryDocumentSnapshot<Object?>> budgets;
    bool hasData = false;

    //refactor this if statement
    //check if there is data, if so set hasData to true

    budgets = snapshot.hasData ? snapshot.data!.docs : [];

    if(budgets.isNotEmpty){
      hasData = true;
    }
    return
      Column(
      children: [
        mainBudgetInfo(),
        SizedBox(
          height: 0.5,
        ),
        monthSliderYearDropdown(),

        Container(
          width: 330,
          height: 400,
          child: hasData?
          GridView.builder(
            addAutomaticKeepAlives: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery
                  .of(context)
                  .size
                  .width / (MediaQuery
                  .of(context)
                  .size
                  .height / 1.7),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: budgets!.length,
            itemBuilder: (BuildContext context, int index) {
              //return current budget

              //keep track if the row finished
              rowFinished = index % 2 == 0 ? 1 : 0;
              //need to check the values of the colors, if they right we need to flip, if flipped return to normal
              if (rowFinished == 1) {
                if (firstColor == condition) {
                  //the colors arent flipped, so we flip them
                  firstColor = secondColor;
                  secondColor = isDark?Color.fromRGBO(200, 70, 200, 1):Color(0xFF34cfb3);
                } else {
                  firstColor = isDark?Color.fromRGBO(200, 70, 200, 1):Color(0xFF34cfb3);
                  secondColor = isDark?Colors.deepPurple:Color(0xFF4B9EB8);
                }
              }
              Budget passed = Budget.fromJson(budgets.elementAt(index).data() as Map<String, dynamic>);
              //now we need to check if the item is first or second in the row
              return buildBudgetCard(
                  index % 2 != 0 ? firstColor : secondColor,
                  budgets[index]['name'],
                  budgets[index]['amount'].toString(),
                  budgets[index]['amount'].toString(),
                  passed
              );
            },
          ):noFoundBudget()
          ,
        ),
      ],
    );
  }

  Widget mainBudgetInfo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
          child: FutureBuilder(
            future: Provider.of<DatabaseProvider>(context).getAllAttributes(currentMonthIndex + 1,int.parse(_selectedYear)),
            //[0] is the remaining, [1] is the total, [2] is the spent
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return CircularProgressIndicator();
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                if(!doOnce){
                      return CircularProgressIndicator();
                    }
                  }
              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${translation(context).remaining}", style: TextStyle(fontFamily: "K2D", fontSize: 22, color: isDark?Colors.white:Color(0XFF145756), fontWeight: FontWeight.bold),),
                    Text("${snapshot.data![0]} \$", style: TextStyle(fontFamily: "K2D", fontSize: 50, color: isDark?Colors.white:Color(0XFF145756), fontWeight: FontWeight.bold),),
                  ],
                ),

      SizedBox(width: 30),
      Column(
        children: [
              Column(
                  children: [
                  Text("${translation(context).spent}", style: TextStyle(fontFamily: "K2D", fontSize: 18, color: isDark?Colors.white:Color(0XFF145756), fontWeight: FontWeight.bold),),
                  Text("\-${snapshot.data![2]} \$", style: TextStyle(fontFamily: "K2D", fontSize: 16, color: isDark?Colors.white:Color(0XFF145756), fontWeight: FontWeight.bold),),
                ]
              ),
              SizedBox(height: 10,),
                  Column(children: [
                    Text("${translation(context).total}", style: TextStyle(fontFamily: "K2D", fontSize: 18, color: isDark?Colors.white:Color(0XFF145756), fontWeight: FontWeight.bold),),
                    Text(
                      "\+${snapshot.data![1]} \$",
                      style: TextStyle(
                          fontFamily: "K2D",
                          fontSize: 16,
                          color: isDark?Colors.white:Color(0XFF145756),
                          fontWeight: FontWeight.bold),
                    )
                  ])
                ],
      ),
    ]);
            }
          )
    ));
  }


  Widget monthSliderYearDropdown(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 40,
          width: 170,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isDark?Color.fromRGBO(159, 79, 248, 1):Color.fromRGBO(123, 203, 201, 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    currentMonthIndex = (currentMonthIndex - 1) % 12;
                    Provider.of<DateProvider>(context,listen: false).month = currentMonthIndex;
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
                      DateTime.now().month,
                      Provider.of<DateProvider>(context,listen: false).month + 1 ) )
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
                    Provider.of<DateProvider>(context,listen: false).month = currentMonthIndex;
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
                    color: isDark?Color.fromRGBO(159, 79, 248, 1):Color.fromRGBO(123, 203, 201, 1)),
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


  Widget noFoundBudget() {
    return Stack(
        clipBehavior: Clip.none, alignment: Alignment.topCenter,
        children: [
          Positioned(
              top: 100.0,
              child: Text(
                "${translation(context).budgetQuote}",
                style: TextStyle(
                  fontSize: 40.0,
                  fontFamily: "K2D",
                  color: isDark?Colors.white:Colors.black
                ),
              )
          )
        ]
    );

  }

  Widget evalTabForm(TabController controller, DatabaseProvider provider , BuildContext context) {
    switch (controller.index) {
      case 0:
        return BudgetForm();
        break;
      case 1:
        return ExpenseForm(currentMonthIndex: 5,);
        break;
      default:
        return BudgetForm();
    }
  }

}



