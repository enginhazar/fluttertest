import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasetest/core/helper/shared_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class GoogleSigninHelper {
  static GoogleSigninHelper _instance = GoogleSigninHelper._private();

  GoogleSigninHelper._private();

  static GoogleSigninHelper get instance => _instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<GoogleSignInAccount> signin() async {
    final user = await _googleSignIn.signIn();
    if (user != null) {
      return user;
    }
    return null;
  }

  Future<GoogleSignInAuthentication> googleAuthentice() async {
    if (await _googleSignIn.isSignedIn()) {
      final user = _googleSignIn.currentUser;
      final userData = await user.authentication;

      return userData;
    }
  }

  Future<void> signOut() async {
    final user = await _googleSignIn.signOut();
    if (user != null) {
      print(user.email);
      return user;
    }
    return null;
  }

  bool get isHaveUser => user != null ? true : false;
  GoogleSignInAccount get user => _googleSignIn.currentUser;

  Future<FirebaseUser> firebaseSignin() async {
    final GoogleSignInAuthentication googleAuth = await googleAuthentice();
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    print("signed in-1 " + user.displayName);
    var tokenResult = await user.getIdToken();
    //Logger(token.token);
    SharedManager.instance.setString(SharedEnum.TOKEN, tokenResult.token);

    return user;
  }
}
