import 'package:flutter/material.dart';
import 'package:freelance/models/user.dart';
import 'package:freelance/providers/info.dart';
import 'package:freelance/screens/auth_screen.dart';
import 'package:freelance/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = 'splash';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _firstTime = true;

  Future<void> _navigate(BuildContext context) async {
    bool _isLoggedIn = await Provider.of<Info>(context, listen: false).token();

    if (_isLoggedIn) {
      final _prefs = await SharedPreferences.getInstance();

      User _user = User(
        id: _prefs.getString("id"),
        name: _prefs.getString("name"),
        phoneNumber: _prefs.getInt("phoneNumber"),
      );

      Provider.of<Info>(context, listen: false).setUser(user: _user);
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } else {
      Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _navigate(context);
      _firstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: Colors.lightGreen,
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: Image(
            height: 200,
            width: 200,
            image: AssetImage("assets/images/freelance.png"),
          ),
        ),
      ),
    );
  }
}
