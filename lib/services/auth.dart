import 'package:audioapp/models/appUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FirebaseUser
  AppUser? _appUserFromFirebaseUser(User? user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<AppUser?> get getUser {
    return _auth.authStateChanges()
        // .map((User? user) => _appUserFromFirebaseUser(user));
      .map(_appUserFromFirebaseUser);
  }

  // sign in anonymously
  Future signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _appUserFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
}

  // sign in with email and password

  // register with email and password

  // sign out

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

}