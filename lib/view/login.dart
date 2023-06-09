// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testapp/viewmodel/firebase_controller.dart';

import 'budget_page.dart';


const Color FontColour = Color(0x666666);
final FirebaseController _auth = FirebaseController();
var style = GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black));

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginPageWidget(),
    );
  }

  Widget loginPageWidget() {

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: isDark?Color.fromRGBO(43, 40, 57, 1):Color.fromRGBO(255, 255, 255, 100),
          image: DecorationImage(image: isDark?AssetImage("assets/images/background-dark.jpg"):AssetImage("assets/images/background.jpg"),fit: BoxFit.fill,opacity: 0.2)
        // gradient: LinearGradient(
        //   colors: [
        //     Color(0xFF3FCFA4), // left color
        //     Color(0xFF20A2A2), // right color
        //   ],
        //   begin: Alignment.centerLeft,
        //   end: Alignment.centerRight,
        // )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 150,),
          Padding(
            //TODO: replace with logo
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              width: 500,
              height: 100,
              //Please upload the image when committing :)
              // child: Image.asset("assets/images/PlaceholderLogo.png"),
              child: Text(
                "My Budgeteer",
                style: TextStyle(
                    fontSize: 45,
                    color: isDark?Colors.white:Colors.black,
                    fontFamily: 'K2D',
                    fontWeight: FontWeight.bold),),
            )
          ),
        Text(
          "Money talks, \n"
            "but budgeting screams success!\n",
          style: TextStyle(
              fontSize: 20,
              color: isDark?Colors.white:Colors.black,
              fontFamily: 'K2D'),
        ),
        SizedBox(height: 70,),
          Expanded(
            child: Container(
              width: 500,
              decoration: BoxDecoration(
                  color: isDark?Color.fromRGBO(58, 55, 70, 100):Colors.white,
                  border: Border.all(color: Colors.grey,),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(60),topRight: Radius.circular(60),)
              ),
              child: Column(
                children: [
                  SizedBox(height: 70,),
                  SignInWithGoogleButton(),
                  SizedBox(height: 30,),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget SignInWithGoogleButton(){
    return SizedBox(
      height: 50,
      width: 300,
      child: ElevatedButton(

        style: ElevatedButton.styleFrom(
          backgroundColor: isDark?Color.fromRGBO(43, 40, 57, 1):Colors.white,
          elevation: 0,
          side: BorderSide(color: Colors.grey.shade300),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
        ),
        onPressed:  () async {
          try {
            UserCredential userCredential = await FirebaseController().signInWithGoogle(context);
            // signin is a success
            print(userCredential.user?.displayName);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BudgetPage()));

          } catch (e) {
            // handle error
            print('Error during sign-in: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
              ),
            );
          }
        },



        child: Row(
          children: [
            SizedBox(width: 20,),
            Container(
              child: Image.asset("assets/images/google.png",width: 30,height: 30,),
            ),SizedBox(width: 40,),
            Text(
              "Continue with Google",
              style: TextStyle(
                  fontSize: 15,
                  color: isDark?Colors.white:Colors.black,
                  fontFamily: 'K2D'),
            )
          ],
        ),
      )
    );
  }

}
