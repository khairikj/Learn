import 'package:flutter/material.dart';
import 'package:learn/model/update.dart';
import 'package:learn/model/user.dart';
import 'package:learn/services/auth.dart';
import 'package:learn/services/database.dart';
import 'package:provider/provider.dart';
import 'package:learn/screens/user/customer/shopTile.dart';

class HomeCust extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final shops = Provider.of<List<UserData>>(context) ?? [];

    return StreamProvider<List<UpdAcc>>.value(
        value: DatabaseService().user,
        child: Scaffold(
            body: Container(
          child: ListView.builder(
            itemCount: shops.length,
            itemBuilder: (context, index) {
              return ShopTile(shop: shops[index]);
            },
          ),
        )));
  }
}
