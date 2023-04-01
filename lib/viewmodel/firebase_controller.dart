import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<UserCredential> signInWithGoogle() async {
      //TODO:check token expiration!!!

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);

  }

  signOutUser() {
    firebaseAuth.signOut();
  }
}