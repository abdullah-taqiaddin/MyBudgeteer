// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:testapp/view/statistics_page.dart';
import 'package:testapp/view/settings.dart';

import 'package:testapp/viewmodel/firebase_controller.dart';

import '../view/budget_page.dart';
import '../view/login.dart';

import 'package:testapp/viewmodel/localization.dart';

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
            backgroundColor: isDark?Color.fromRGBO(43, 40, 57, 1):Colors.white,
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
                        builder: (BuildContext dialogContext) {
                          return Builder(
                            builder: (BuildContext context) {
                              return AlertDialog(
                                alignment: Alignment.center,
                                elevation: 250,
                                backgroundColor: isDark?Color.fromRGBO(43, 40, 57, 1):Colors.white,
                                title: Text(
                                  '${translation(context).logout}',
                                  style: TextStyle(
                                    color: isDark?Colors.white:Colors.black,
                                    fontFamily: "K2D",
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                content: Container(
                                  width: 220,
                                  child: Text(
                                    '${translation(context).logoutConfirmation}',
                                    style: TextStyle(
                                      color: isDark?Colors.white:Color(0XFF145756),
                                      fontFamily: "K2D",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                actions: [
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 130,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: isDark?Color.fromRGBO(159, 79, 248, 1):Color.fromRGBO(255, 107, 53, 1),
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                          ),
                                          child: TextButton(
                                            child: Text(
                                              '${translation(context).logout}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "K2D",
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: () {
                                              FirebaseController().signOutUser(context);
                                              Navigator.of(dialogContext).pushAndRemoveUntil(
                                                MaterialPageRoute(builder: (context) => loginPage()),
                                                    (route) => false,
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 3,),
                                        Container(
                                          width: 130,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.black26),
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                          ),
                                          child: TextButton(
                                            child: Text(
                                              '${translation(context).cancel}',
                                              style: TextStyle(
                                                color: Color(0XFF145756),
                                                fontFamily: "K2D",
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(dialogContext);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
