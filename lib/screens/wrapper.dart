import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn/model/user.dart';
import 'package:learn/screens/authenticate/authenticate.dart';
import 'package:learn/screens/user/customer/navCust.dart';
import 'package:learn/screens/user/owner/navOwner.dart';
import 'package:learn/services/auth.dart';
import 'package:learn/services/database.dart';
import 'package:learn/shared/loading.dart';
import 'package:provider/provider.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String uid = auth.currentUser.uid.toString();

class Wrapper extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserUid>(context);
    print(user);
    

    //return either Home or Authenticate
    CollectionReference users = FirebaseFirestore.instance.collection('User');

    if (user == null) {
      
      return Authenticate();
    } else {
      return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData && snapshot.data != null) {
          DatabaseService();
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection("User").doc(snapshot.data.uid).snapshots() ,
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
              if(snapshot.hasData && snapshot.data != null) {
                final userDoc = snapshot.data;
                final user = userDoc.data();
                if(user['userType'] == 'Owner') {
                  return NavOwner();
                }else{
                  return NavCust();
                }
              }else{
                return Loading();
              }
            },
          );
        }
        return Authenticate();
      }
    );
    }

    
  }
}