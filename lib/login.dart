import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

const Color FontColour = Color(0x666666);


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
    //icon
    //at the end
    //continue with google button
    //continue as guest button

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color(0xD2D2D2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 100,),
          Padding(
            //TODO: replace with logo
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 300,
              height: 200,
              color: Colors.grey,
            )
          ),
        SizedBox(height: 100,),
          Container(
            width: 500,
            height: 267,
            decoration: BoxDecoration(

                border: Border.all(color: Colors.grey,),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(60),topRight: Radius.circular(60),)
            ),
            child: Column(
              children: [
                SizedBox(height: 50,),
                SignInWithGoogle(),
                SizedBox(height: 50,),
                Row(
                    children: [
                      const Expanded(
                          child: Divider(color: Colors.black,indent: 50,)
                      ),
                      TextButton(child: Text("Continue as a guest",style: TextStyle(color: Colors.black),),onPressed: (){},),
                      const Expanded(
                          child: Divider(color: Colors.black,endIndent: 50,)
                      ),
                    ]
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget SignInWithGoogle(){
    return SizedBox(
      height: 50,
      width: 300, // set your desired width here
      child: ElevatedButton(

        /*style: ButtonStyle(

          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
        ),*/
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          elevation: 0,
          side: BorderSide(color: Colors.grey.shade300),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
        ),
        //TODO:implement firebase auth
        onPressed: (){},

        child: Row(
          children: [
            SizedBox(width: 20,),
            Container(
              child: Image.asset("assets/images/google.png",width: 30,height: 30,),
            ),SizedBox(width: 40,),
            Text("Continue with Google",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w400),)
          ],
        ),
      )
    );
  }

}
