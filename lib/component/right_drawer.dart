
import 'package:flutter/material.dart';

import 'package:testapp/viewmodel/firebase_controller.dart';

import '../pages/budget_page.dart';

class RightDrawer extends StatelessWidget {
  const RightDrawer({Key? key}) : super(key: key);

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
            backgroundColor: Colors.blueGrey[100],
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 150),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(Icons.home),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BudgetPage()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(Icons.bar_chart),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(Icons.settings),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Divider(color: Colors.grey,  indent: 15, endIndent: 15),
                  ListTile(
                    leading: Icon(Icons.logout),
                    //TODO:Continue the provider and route to login-page
                    onTap: FirebaseController().signOutUser(),
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
