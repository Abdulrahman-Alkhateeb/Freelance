import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freelance/providers/info.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

enum AuthMode {
  Login,
  SignUp,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = 'auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.Login;
  double _containerHeight = 350;
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, String> _authData = {};

  void _changeAuthMode() {
    setState(() {
      _formKey.currentState.reset();
      if (_authMode == AuthMode.Login) {
        _authMode = AuthMode.SignUp;
        _containerHeight = 580;
      } else {
        _authMode = AuthMode.Login;
        _containerHeight = 350;
      }
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        if (_authMode == AuthMode.SignUp) {
          _containerHeight = 540;
        } else {
          _containerHeight = 350;
        }
      });
      if (_authMode == AuthMode.Login) {
        bool result = await Provider.of<Info>(context, listen: false).login(
          username: _authData["username"],
          password: _authData["password"],
        );
        if (result) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        } else {
          print("asd");
        }
      }
      if (_authMode == AuthMode.SignUp) {
        bool result = await Provider.of<Info>(context, listen: false).signup(
          username: _authData["username"],
          password: _authData["password"],
          fullName: _authData["fullName"],
          phoneNumber: _authData["phoneNumber"],
        );
        if (result) {
          _changeAuthMode();
        } else {
          print("asd");
        }
      }
    } else {
      setState(() {
        if (_authMode == AuthMode.SignUp)
          _containerHeight = 590;
        else
          _containerHeight = 390;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 35,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.lightGreen,
                    ),
                    color: Colors.white,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image(
                    height: 150,
                    width: 150,
                    image: AssetImage("assets/images/freelance.png"),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Container(
                  width: double.infinity,
                  height: _containerHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        if (_authMode == AuthMode.SignUp)
                          SizedBox(
                            height: 20,
                          ),
                        if (_authMode == AuthMode.SignUp)
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Full Name',
                            ),
                            validator: (value) {
                              if (value.isEmpty)
                                return "Please Enter Your Name";
                              return null;
                            },
                            onSaved: (newValue) =>
                                _authData['fullName'] = newValue,
                          ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                          ),
                          validator: (value) {
                            if (value.isEmpty)
                              return "Please Enter Your Username";
                            return null;
                          },
                          onSaved: (newValue) =>
                              _authData['username'] = newValue,
                        ),
                        if (_authMode == AuthMode.SignUp)
                          SizedBox(
                            height: 20,
                          ),
                        if (_authMode == AuthMode.SignUp)
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Phone Number',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.isEmpty)
                                return "Please Enter Your Phone Number";
                              return null;
                            },
                            onSaved: (newValue) =>
                                _authData['phoneNumber'] = newValue,
                          ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                          validator: (value) {
                            if (value.isEmpty)
                              return "Please Enter Your Password";
                            return null;
                          },
                          onSaved: (newValue) =>
                              _authData['password'] = newValue,
                          controller: _passwordController,
                        ),
                        if (_authMode == AuthMode.SignUp)
                          SizedBox(
                            height: 20,
                          ),
                        if (_authMode == AuthMode.SignUp)
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Confirm Password',
                            ),
                            validator: (value) {
                              if (value != _passwordController.text)
                                return "Passwords don't match!";
                              return null;
                            },
                          ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            color: Colors.lightGreen,
                            child: Text(
                              _authMode == AuthMode.Login ? "Login" : "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            onPressed: _submit,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.lightGreen,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            color: Colors.white,
                            child: Text(
                              _authMode == AuthMode.Login ? "Sign Up" : "Login",
                              style: TextStyle(
                                color: Colors.lightGreen,
                                fontSize: 20,
                              ),
                            ),
                            onPressed: _changeAuthMode,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
