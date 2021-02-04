import 'package:flutter/services.dart';
import 'package:learn/screens/user/accDetail.dart';
import 'package:learn/screens/user/accountUpdate.dart';
import 'package:learn/screens/user/owner/historyOwner.dart';
import 'package:learn/screens/user/owner/homeOwner.dart';
import 'package:learn/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:learn/services/database.dart';
import 'package:provider/provider.dart';
import 'package:learn/model/update.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class NavOwner extends StatefulWidget {
  @override
  _NavOwnerState createState() => _NavOwnerState();
}

class _NavOwnerState extends State<NavOwner> {
  int _selectedIndex = 0;
  String qrCode = 'Unknown';
  List<Widget> _widgetOptions = <Widget>[
    AccountDetail(),
    HomeOwner(),
    HistoryOwner(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final AuthService _auth = AuthService();
  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode;
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UpdAcc>>.value(
        value: DatabaseService().user,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            centerTitle: true,
            title: Text('MyBooking'),
            leading: Container(),
          ),
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          endDrawer: Drawer(
              elevation: 5.0,
              child: ListView(children: <Widget>[
                ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit account info'),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AccUpd()));
                    }),
                ListTile(
                  leading: Icon(Icons.design_services),
                  title: Text('Edit service'),
                  onTap: null,
                ),
                ListTile(
                  leading: Icon(Icons.qr_code_scanner),
                  title: Text('Scan QR Code'),
                  onTap: () => scanQRCode(),
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () async {
                    await _auth.signOut();
                  },
                ),
              ])),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Account'),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.book), label: 'History'),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTap,
            fixedColor: Colors.red,
          ),
        ));
  }
}
