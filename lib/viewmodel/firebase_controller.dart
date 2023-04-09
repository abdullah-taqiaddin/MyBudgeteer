import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:testapp/viewmodel/auth_provider.dart';
import 'package:testapp/model/user_model.dart';

final firebaseAuth = FirebaseAuth.instance;

class FirebaseController{

  UserModel? userFromFirebase(User? user){
    return user != null ? UserModel(uid: user.uid): null;
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

        Provider.of<AuthProvider>(context, listen: false).setUserCredentials(userCredential);
        return userCredential;

      } catch (e) {
        // Sign the user out and try again
        await GoogleSignIn().signOut();
        return signInWithGoogle(context);
      }

  }

  signOutUser(BuildContext context) {
    try {
      Provider.of<AuthProvider>(context, listen: false).removeUserCredentials();
      firebaseAuth.signOut();
    }
    catch(e){
      //TODO:Make a snackbar if any errors occure
      print(e);
    }
  }
}