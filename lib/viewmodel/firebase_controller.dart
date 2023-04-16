import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/viewmodel/auth_provider.dart';
import 'package:testapp/model/user_model.dart';

final firebaseAuth = FirebaseAuth.instance;

class FirebaseController{

  UserModel? userFromFirebase(User? user){
    return user != null ? UserModel(uid: user.uid, displayName: user.displayName!): null;
  }


  Future signInAnonymously(BuildContext context) async {
    try
    {
      final UserCredential userCredential = await firebaseAuth.signInAnonymously();
      User? user = userCredential.user;

      Provider.of<AuthProvider>(context, listen: false).setUserCredentials(userCredential);
      return userFromFirebase(user);
    }
    catch(e)
    {
      print(e.toString());
      //retry sign in if failed
      return signInAnonymously(context);
    }

  }



  /*TODO:
  * 1. Link with provider
  * 2. Link with firebase database once authenticated
  * 3. differentiate new users from old ones
  * */

  bool isTokenExpired() {
    return false;
  }
  //
  // Future<UserCredential> signInWithGoogle(BuildContext context) async {
  //
  //     // Trigger the authentication flow
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //
  //     // Create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken,
  //       idToken: googleAuth?.idToken,
  //     );
  //
  //
  //     try {
  //       // Once signed in, return the UserCredential
  //       final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  //
  //       Provider.of<AuthProvider>(context, listen: false).setUserCredentials(userCredential);
  //       return userCredential;
  //
  //     } catch (e) {
  //       // Sign the user out and try again
  //       await GoogleSignIn().signOut();
  //       return signInWithGoogle(context);
  //     }
  //
  // }

  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    try {
      //نسيف لل sharedpreferences
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      await saveUserCredentials(userCredential);
      Provider.of<AuthProvider>(context, listen: false).setUserCredentials(userCredential);
      print(userCredential);
      return userCredential;
    } catch (e) {
      print(e);

      await GoogleSignIn().signOut();
      //try and sign in again?
      //TODO:research a better way
      return signInWithGoogle(context);
    }
  }

  Future<void> saveUserCredentials(UserCredential userCredential) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('userEmail', userCredential.user!.email!);
    await prefs.setString('userPassword', userCredential.credential!.token!.toString());
    print(prefs.toString());

  }

  signOutUser(BuildContext context) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      //we need to clear the local storage
      pref.clear();
      Provider.of<AuthProvider>(context, listen: false).removeUserCredentials();
      firebaseAuth.signOut();

    }
    catch(e){
      //TODO:Make a snackbar if any errors occure
      print(e);
    }
  }
}