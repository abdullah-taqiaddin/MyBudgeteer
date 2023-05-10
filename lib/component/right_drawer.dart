import 'package:flutter/material.dart';
import 'package:testapp/view/statistics_page.dart';
import 'package:testapp/view/settings.dart';

import 'package:testapp/viewmodel/firebase_controller.dart';

import '../view/budget_page.dart';
import '../view/login.dart';

class RightDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  RightDrawer({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: ClipRRect(
        // give it your desired border radius
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(250),
          topLeft: Radius.circular(250),
        ),
        // wrap with a sizedbox for a custom width [for more flexibility]
        child: SizedBox(
          width: 60,
          height: 1000,
          child: Drawer(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 150),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color: selectedIndex == 0 ? Color(0XFF2DB79E) : null,
                    ),
                    onTap: () {
                      if (onItemTapped != 0) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BudgetPage()),
                            (route) => false);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(
                      Icons.bar_chart,
                      color: selectedIndex == 1 ? Color(0XFF2DB79E) : null,
                    ),
                    onTap: () {
                      onItemTapped(1);
                      //TODO:Route to Statistics page
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => StatisticsPage()));
// comment delete
                    },
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: selectedIndex == 2 ? Color(0XFF2DB79E) : null,
                    ),
                    onTap: () {
                      onItemTapped(2);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => settingspage()));
                    },
                  ),
                  Divider(color: Colors.grey, indent: 15, endIndent: 15),
                  ListTile(
                    leading: Icon(Icons.logout),
                    onTap: () {
                      onItemTapped(3);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            elevation: 250,
                            backgroundColor: Colors.white,
                            title: Text(
                              'Sign Out',
                              style: TextStyle(
                                color: Color.fromRGBO(255, 107, 53, 1),
                                fontFamily: "K2D",
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              'Are you sure you want to sign out?',
                              style: TextStyle(
                                color: Color(0XFF145756),
                                fontFamily: "K2D",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            actions: [
                              Container(
                                width: 80,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 107, 53, 1),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomLeft: Radius.circular(30)),
                                ),
                                padding: EdgeInsets.all(10),
                                child: TextButton(
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "K2D",
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    FirebaseController().signOutUser(context);
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => loginPage()),
                                      (route) => false,
                                    );
                                  },
                                ),
                              ),
                              Container(
                                width: 80,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(50),
                                      bottomLeft: Radius.circular(50)),
                                ),
                                padding: EdgeInsets.all(10),
                                child: TextButton(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Color(0XFF145756),
                                      fontFamily: "K2D",
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),

                  /*ListTile(
                    leading: Icon(Icons.logout),
                    onTap: () {
                     onItemTapped(3);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            elevation: 250,
                            backgroundColor: Colors.white,
                            title: Text('Sign Out',
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 107, 53, 1),
                                  fontFamily: "K2D",
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            content: Text('Are you sure you want to sign out?',
                              style: TextStyle(
                                  color: Color(0XFF145756),
                                  fontFamily: "K2D",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            actions: [
                              TextButton(
                                child: Text('Yes',
                                  style: TextStyle(
                                      color: Color(0XFF145756),
                                      fontFamily: "K2D",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  FirebaseController().signOutUser(context);
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => loginPage()),
                                    (route) => false,
                                  );
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: Color(0XFF145756),
                                      fontFamily: "K2D",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
