import 'package:flutter/material.dart';
import 'package:learn/model/update.dart';
import 'package:learn/model/user.dart';

class ShopTile extends StatelessWidget {
  final UserData shop;
  ShopTile({this.shop});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Card(
        elevation: 10.0,
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
              radius: 30.0, backgroundImage: NetworkImage(shop.photoURL)),
          title: Text(shop.name),
          subtitle: Text(shop.address),
          onTap: () {},
        ),
      ),
    );
  }
}
