
import 'package:flutter/material.dart';
import 'package:testapp/view/settings.dart';

import 'package:testapp/viewmodel/firebase_controller.dart';

import '../pages/budget_page.dart';
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
                    leading: Icon(Icons.home,
                      color: selectedIndex == 0 ? Colors.green : null,
                    ),
                    onTap: () {
                      onItemTapped(0);
                      //TODO:FIX ROUTE TO HOME PAGE!
                      if(Navigator.canPop(context)) {
                        print("can pop");
                        Navigator.pop(context);
                      } else {
                        print("Can push");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BudgetPage()),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(Icons.bar_chart,
                      color: selectedIndex == 1 ? Colors.green : null,
                    ),
                    onTap: () {
                      onItemTapped(1);
                      //TODO:Route to Statistics page
                      //Navigator.pop(context);
                    },
                  ),

                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(Icons.settings,
                      color: selectedIndex == 2 ? Colors.green : null,
                    ),
                    onTap: () {
                      onItemTapped(2);
                      Navigator.push(context, new MaterialPageRoute(builder: (context)=>settingspage()));
                    },
                  ),
                  Divider(color: Colors.grey,  indent: 15, endIndent: 15),
                  ListTile(
                    leading: Icon(Icons.logout),
                    //TODO:Continue the provider and route to login-page
                    onTap: () {
                      FirebaseController().signOutUser(context);
                      Navigator.of(context).pushAndRemoveUntil(
                          new MaterialPageRoute(
                              builder: (context) =>
                                  loginPage()),
                              (route) => false);
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
