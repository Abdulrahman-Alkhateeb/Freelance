import 'package:flutter/material.dart';
import 'package:freelance/providers/categories.dart';
import 'package:freelance/providers/info.dart';
import 'package:freelance/providers/items.dart';
import 'package:freelance/screens/add_screen.dart';
import 'package:freelance/screens/auth_screen.dart';
import 'package:freelance/screens/content_screen.dart';
import 'package:freelance/screens/home_screen.dart';
import 'package:freelance/screens/my_items_screen.dart';
import 'package:freelance/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Categories(),
        ),
        ChangeNotifierProvider(
          create: (context) => Items(),
        ),
        ChangeNotifierProvider(
          create: (context) => Info(),
        ),
      ],
      child: MaterialApp(
        title: 'فريلانس',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
        routes: {
          SplashScreen.routeName: (ctx) => SplashScreen(),
          AuthScreen.routeName: (ctx) => AuthScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          AddScreen.routeName: (ctx) => AddScreen(),
          ContentScreen.routeName: (ctx) => ContentScreen(),
          MyItemsScreen.routeName: (ctx) => MyItemsScreen(),
        },
      ),
    );
  }
}
