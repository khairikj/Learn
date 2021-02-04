import 'package:flutter/material.dart';

class AddService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Choose source"),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            GestureDetector(
              child: Text("Gallery"),
              onTap: () {},
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            GestureDetector(
              child: Text("Take new picture"),
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
