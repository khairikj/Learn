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
      return FutureBuilder<DocumentSnapshot>(
      future: users.doc(uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done ) {
          Map<String, dynamic> data = snapshot.data.data();
          var x = data['userType'].toString();
          if (x == 'Owner'){
            print(uid);
            return NavOwner();
          }
          if(x == 'Customer'){
            print(uid);
            return NavCust();
          }
          else {
            print(uid);
            uid = null;
            return Authenticate();
          }
        }
        return Loading();
      },
    );
    }

    
  }
}