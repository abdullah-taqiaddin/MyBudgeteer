// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/component/delete_alert.dart';
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
    Provider.of<DatabaseProvider>(context).uid = user!.uid;

    TabController _tabController = TabController(length: 2, vsync: this);

    return StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
      stream: Provider.of<DatabaseProvider>(context).getBudgets().snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          noData = true;
        }
        if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
        }
        return Builder(
          builder: (context) {
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
                          child: evalTabForm(_tabController, Provider.of<DatabaseProvider>(context)),
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

            body: MainBody(_tabController,user,snapshot),
            );
          }
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

  Widget buildBudgetCard(Color color, String type, String spent, String total, Budget? budget) {
    return InkWell(
      onLongPress: () => {
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeletePopup(id: budget!.id);
      })
      },
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
            child: BudgetForm(initialBudget: budget,),
          ),
        );
      },
      child: Container(
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
      ),
    );
  }

  Widget MainBudgetInfo(String remaining, String spent, String total) {

    var totalamount = Provider.of<DatabaseProvider>(context).getTotalBudgetAmount().toString();

    print("total amount: ${totalamount}");
    String remainingamount;
    String totalspent;

    return FutureBuilder(
      future: Provider.of<DatabaseProvider>(context).getTotalBudgetAmount(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Text("srngj");
        }if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        else{
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
                    "${snapshot.data} \$",
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
      );}}
    );
  }

  Widget budgetTab( AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    Color firstColor = Color(0xFF34cfb3);
    Color lastColor = firstColor;
    Color secondColor = Color(0xFF4B9EB8);
    // 0,1

    int rowFinished = 0;
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
              //return current budget
              //keep track if the row finished
              rowFinished = index % 2 == 0 ? 1 : 0;
              //need to check the values of the colors, if they right we need to flip, if flipped return to normal
              if(rowFinished == 1){
                if(firstColor == Color(0xFF34cfb3)){
                  //the colors arent flipped, so we flip them
                  firstColor = secondColor;
                  secondColor = Color(0xFF34cfb3);
                }else{
                  firstColor = Color(0xFF34cfb3);
                  secondColor = Color(0xFF4B9EB8);
                }
              }


              Budget passed = Budget.fromJson(budgets[index].data());
              print(passed);
              //now we need to check if the item is first or second in the row
              return buildBudgetCard(
                index % 2 != 0 ? firstColor: secondColor,
                budgets[index]['name'],
                budgets[index]['amount'].toString(),
                budgets[index]['amount'].toString(),
                passed
              );
            },
          ),
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
        return BudgetForm();
        break;
      case 1:
        return ExpenseForm();
        break;
      default:
        return BudgetForm();
    }
  }
}

