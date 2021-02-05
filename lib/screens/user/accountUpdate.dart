import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:learn/model/user.dart';
import 'package:learn/services/database.dart';
import 'package:learn/shared/loading.dart';
import 'package:learn/shared/constants.dart';
import 'package:geolocator/geolocator.dart';

class AccUpd extends StatefulWidget {
  @override
  _AccUpdState createState() => _AccUpdState();
}

class _AccUpdState extends State<AccUpd> {
  int selectedRadio;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  var _imageFile;
  String _name;
  String _phoneNum;
  String _address;
  String _location;
  double latitude;
  double longitude;

  var _locationCont = TextEditingController();

  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);

    setState(() {
      _location = '${position.latitude}, ${position.longitude}';
      _locationCont.text = _location;
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _getCurrentLocation();
  }

  Future showChoiceDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose source"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Gallery"),
                  onTap: () {
                    takePhoto(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: Text("Take new picture"),
                  onTap: () {
                    takePhoto(ImageSource.camera);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFIle = await _picker.getImage(source: source);
    setState(() {
      _imageFile = File(pickedFIle.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserUid>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          
            UserData userData = snapshot.data;
            return Form(
                key: _formKey,
                child: Scaffold(
                    backgroundColor: Colors.red[300],
                    appBar: AppBar(
                      title: Text('Update Info'),
                      backgroundColor: Colors.red,
                    ),
                    body: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        child: Form(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 20.0),
                              Stack(
                                children: <Widget>[
                                  new Container(
                                      width: 175.0,
                                      height: 175.0,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                              fit: BoxFit.cover,
                                              image: _imageFile == null
                                                  ? NetworkImage(
                                                      userData.photoURL)
                                                  : FileImage(
                                                      File(_imageFile.path))))),
                                  Positioned(
                                    bottom: 0.0,
                                    right: 0.0,
                                    child: InkWell(
                                      onTap: () => showChoiceDialog(),
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 30.0,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 20.0),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    hintText: userData.name),
                                validator: (val) =>
                                    val.isEmpty ? 'Please enter a name' : null,
                                onChanged: (val) => setState(() => _name = val),
                              ),
                              SizedBox(height: 20.0),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    hintText: userData.phoneNum),
                                validator: (val) => val.isEmpty
                                    ? 'Please enter you phone number'
                                    : null,
                                onChanged: (val) =>
                                    setState(() => _phoneNum = val),
                              ),
                              SizedBox(height: 20.0),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    hintText: userData.address),
                                validator: (val) => val.isEmpty
                                    ? 'Please enter your city address'
                                    : null,
                                onChanged: (val) =>
                                    setState(() => _address = val),
                              ),
                              SizedBox(height: 20.0),
                              TextFormField(
                                controller: _locationCont,
                                decoration: textInputDecoration.copyWith(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      _getCurrentLocation();
                                    },
                                    icon: Icon(Icons.location_searching),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: BorderSide(color: Colors.red)),
                                  color: Colors.red[800],
                                  child: Text(
                                    'Update',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    if(userData.userType == 'Owner'){
                                      if (_formKey.currentState.validate()) {
                                      Random i = new Random();
                                      int j = i.nextInt(10000);
                                      final ref = FirebaseStorage.instance
                                          .ref()
                                          .child('image$j');
                                      await ref.putFile(_imageFile);
                                      await ref
                                          .getDownloadURL()
                                          .then((value) async {
                                        await DatabaseService(uid: user.uid)
                                            .updateUserData(
                                                _name ?? userData.name,
                                                _phoneNum ?? userData.phoneNum,
                                                _address ?? userData.address,
                                                _location ?? userData.location,
                                                value ?? userData.photoURL,
                                                userType: 'Owner');
                                        Navigator.pop(context);
                                      });
                                    }
                                    }
                                    else{
                                      if (_formKey.currentState.validate()) {
                                      Random i = new Random();
                                      int j = i.nextInt(10000);
                                      final ref = FirebaseStorage.instance
                                          .ref()
                                          .child('image$j');
                                      await ref.putFile(_imageFile);
                                      await ref
                                          .getDownloadURL()
                                          .then((value) async {
                                        await DatabaseService(uid: user.uid)
                                            .updateUserData(
                                                _name ?? userData.name,
                                                _phoneNum ?? userData.phoneNum,
                                                _address ?? userData.address,
                                                _location ?? userData.location,
                                                value ?? userData.photoURL,
                                                userType: 'Customer');
                                        Navigator.pop(context);
                                      });
                                    }
                                    }

                                  })
                            ],
                          ),
                        ))));
          
        });
  }
}
