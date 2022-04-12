import 'package:flutter/material.dart';
import 'package:freelance/models/category.dart';
import 'package:freelance/models/item.dart';
import 'package:freelance/providers/categories.dart';
import 'package:freelance/screens/add_screen.dart';
import 'package:freelance/screens/auth_screen.dart';
import 'package:freelance/screens/my_items_screen.dart';
import 'package:freelance/widgets/category_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> _cats = [];
  bool _isLoading = true, _firstTime = true;

  Future<void> _getCats() async {
    _cats = await Provider.of<Categories>(context, listen: false).categories();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _getCats();
      _firstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 175),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pushNamed(MyItemsScreen.routeName);
                    },
                    title: Text(
                      'My Items',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    leading: Icon(
                      Icons.history,
                      size: 25,
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      SharedPreferences _prefs =
                          await SharedPreferences.getInstance();
                      _prefs.clear();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AuthScreen.routeName,
                        (route) => false,
                      );
                    },
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    leading: Icon(
                      Icons.exit_to_app,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.hardEdge,
              child: Container(
                width: double.infinity,
                height: 200,
                color: Colors.lightGreen,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        clipBehavior: Clip.hardEdge,
                        padding: const EdgeInsets.all(20),
                        height: 100,
                        width: 100,
                        child: Image(
                          height: 100,
                          width: 100,
                          image: AssetImage('assets/images/freelance.png'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Freelance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightGreen,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        onTap: (value) async {
          switch (value) {
            case 0:
              var result = await Navigator.of(context).pushNamed(
                AddScreen.routeName,
                arguments: {
                  'type': ItemType.Offer,
                },
              );
              if (result == 'refresh') _getCats();
              break;
            case 1:
              var result = await Navigator.of(context).pushNamed(
                AddScreen.routeName,
                arguments: {
                  'type': ItemType.Request,
                },
              );
              if (result == 'refresh') _getCats();
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Offer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Request',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _cats.isEmpty
              ? Center(
                  child: Text(
                    'No Categories Yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                )
              : GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  children: _cats
                      .map(
                        (cat) => CategoryCard(
                          category: cat,
                        ),
                      )
                      .toList(),
                ),
    );
  }
}
