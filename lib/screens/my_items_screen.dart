import 'package:flutter/material.dart';
import 'package:freelance/models/item.dart';
import 'package:freelance/providers/info.dart';
import 'package:freelance/providers/items.dart';
import 'package:freelance/widgets/content_card.dart';
import 'package:provider/provider.dart';

class MyItemsScreen extends StatefulWidget {
  static const String routeName = 'my-items';

  @override
  _MyItemsScreenState createState() => _MyItemsScreenState();
}

class _MyItemsScreenState extends State<MyItemsScreen> {
  List<Item> _items = [];
  bool _firstTime = true, _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _getItems();
      _firstTime = false;
    }
  }

  Future<void> _getItems() async {
    String _userId = Provider.of<Info>(context, listen: false).user.id;

    bool result = await Provider.of<Items>(
      context,
      listen: false,
    ).getUserItems(
      userId: _userId,
    );

    if (result) {
      setState(() {
        _items = Provider.of<Items>(
          context,
          listen: false,
        ).userItems;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          "My Items",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _items.isEmpty
              ? Center(
                  child: Text(
                    'You Haven\'y Added Any Items Yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) => ContentCard(
                    context: context,
                    item: _items[index],
                  ),
                  itemCount: _items.length,
                ),
    );
  }
}
