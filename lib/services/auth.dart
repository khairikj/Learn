import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:learn/model/user.dart';
import 'package:learn/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  String url =
      'https://firebasestorage.googleapis.com/v0/b/learn-9efcc.appspot.com/o/169bf475-f372-4b62-b688-8f1323202785.jpg?alt=media&token=295a05ab-151e-4613-b062-156056707793';

  //create user base on firebaseUser
  UserUid _userFromFirebaseUser(User user) {
    return user != null ? UserUid(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<UserUid> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailandPassword(
      String email, String password, String userType) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      //create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData(
          'Name', 'Phone Number', 'Address', 'Location', '$url',
          userType: userType);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
