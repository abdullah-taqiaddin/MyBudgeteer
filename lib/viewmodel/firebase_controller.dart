import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:testapp/viewmodel/auth_provider.dart';

final firebaseAuth = FirebaseAuth.instance;

class FirebaseController{

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
      firebaseAuth.signOut();
      Provider.of<AuthProvider>(context, listen: false).removeUserCredentials();
    }
    catch(e){
      print(e);
    }
  }
}