import 'package:flutter/material.dart';
import 'package:learn/screens/user/owner/addService.dart';

class HomeOwner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.bottomRight,
            child: MaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddService()));
              },
              color: Colors.red,
              textColor: Colors.white,
              child: Icon(
                Icons.add,
                size: 20,
              ),
              padding: EdgeInsets.all(16),
              shape: CircleBorder(),
            )));
  }
}
