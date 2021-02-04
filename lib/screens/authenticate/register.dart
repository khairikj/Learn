import 'package:flutter/material.dart';
import 'package:learn/services/auth.dart';
import 'package:learn/shared/constants.dart';
import 'package:learn/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String userType;

  int selectedRadio;
  void initState() {
    super.initState();
    selectedRadio = 0;
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.red[300],
            appBar: AppBar(
              backgroundColor: Colors.red[500],
              elevation: 1.0,
              title: Text('SIGN UP'),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (val) =>
                            val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        }),
                    SizedBox(height: 20.0),
                    TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        obscureText: true,
                        validator: (val) => val.length < 6
                            ? 'Enter a password 6+ chars long'
                            : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        }),
                    SizedBox(height: 20.0),
                    RadioListTile(
                      value: 1,
                      groupValue: selectedRadio,
                      activeColor: Colors.white,
                      title: Text('Owner'),
                      onChanged: (val) {
                        print('Radio $val');
                        setSelectedRadio(val);
                      },
                    ),
                    RadioListTile(
                      value: 2,
                      groupValue: selectedRadio,
                      activeColor: Colors.white,
                      title: Text('Customer'),
                      onChanged: (val) {
                        print('Radio $val');
                        setSelectedRadio(val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                        color: Colors.red,
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);

                            if (selectedRadio == 1) {
                              userType = "Owner";
                            } else {
                              userType = "Customer";
                            }

                            dynamic result =
                                await _auth.registerWithEmailandPassword(
                                    email, password, userType);
                            if (result == null) {
                              setState(() {
                                error = 'Please supply a valid email';
                                loading = false;
                              });
                            }
                          }
                        }),
                    SizedBox(height: 15.0),
                    Container(
                      child: InkWell(
                          child: new Text(
                              'Already have an account? Click here to LOGIN'),
                          onTap: () {
                            widget.toggleView();
                          }),
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
