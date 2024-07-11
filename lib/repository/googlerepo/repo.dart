import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


 

class AuthRepo {
   final GoogleSignIn _googleSignIn = GoogleSignIn();
 
   Future<User?> signinWithGoogle() async {
    try {

         _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await  _googleSignIn.signIn();

     
      if (googleUser == null) return null;
      final googleAuth = await googleUser.authentication;
      final credentials = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credentials);
      return userCredential.user;
    } catch (e) {
      print(e);

      return null;
    }
  }
}



