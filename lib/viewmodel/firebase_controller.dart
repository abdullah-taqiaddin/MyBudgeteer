

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:testapp/viewmodel/auth_provider.dart';
import 'package:testapp/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final firebaseAuth = FirebaseAuth.instance;

class FirebaseController{

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();



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

        // Once signed in, return the UserCredential
        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final user = userCredential.user;

        //store in firebase firestore
        // //TODO:check if the user already exist
        UserModel newuser = new UserModel(uid: user!.uid, displayName: user.displayName!);
        var docUser = FirebaseFirestore.instance.collection('users').doc(user.uid);
        docUser.set(newuser.toJson());
        print("added user");

        Provider.of<AuthProvider>(context, listen: false).setUser(user);


        print(userCredential);
        saveLocalUser(user);
        return userCredential;

      } catch (e) {
        // Sign the user out and try again
        return signInWithGoogle(context);
      }

  }

  signOutUser(BuildContext context) async{
    try {
      Provider.of<AuthProvider>(context, listen: false).removeUser();
      clearLocalUser();
      await GoogleSignIn().signOut();

      firebaseAuth.signOut();
    }
    catch(e){
      //TODO:Make a snackbar if any errors occure
      print(e);
    }
  }

  void saveLocalUser(User user) async{
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("loggedIn", true);

  }

  void clearLocalUser() async{
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("loggedIn", false);
  }
}