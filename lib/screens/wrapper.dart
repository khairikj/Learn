import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn/model/user.dart';
import 'package:learn/screens/authenticate/authenticate.dart';
import 'package:learn/screens/user/customer/navCust.dart';
import 'package:learn/screens/user/owner/navOwner.dart';
import 'package:learn/services/auth.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserUid>(context);
    print(user);

    //return either Home or Authenticate
    if (user == null) {
      return Authenticate();
    } else {
      return NavCust();
    }
  }
}