import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freelance/models/item.dart';
import 'package:freelance/providers/items.dart';
import 'package:freelance/widgets/content_card.dart';
import 'package:provider/provider.dart';

class ContentScreen extends StatefulWidget {
  static const String routeName = "Content";
  static bool firstTime = true;

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen>
    with SingleTickerProviderStateMixin {
  String _title;
  bool _isLoading = true;
  String _catId;
  TabController _controller;
  List<Item> _requests = [];
  List<Item> _offers = [];

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ContentScreen.firstTime) {
      Map<String, dynamic> _data = ModalRoute.of(context).settings.arguments;
      _title = _data['title'];
      _catId = _data['catId'];
      _getItems();
      ContentScreen.firstTime = false;
    }
  }

  Future<void> _getItems() async {
    await Provider.of<Items>(context, listen: false).getItems(catId: _catId);
    _offers = Provider.of<Items>(context, listen: false).offers();
    _requests = Provider.of<Items>(context, listen: false).requests();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            _title ?? "",
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            controller: _controller,
            tabs: [
              Tab(
                child: Text(
                  'Offers',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Requests',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _offers.isEmpty
                    ? Center(
                        child: Text(
                          'No Offers Yet',
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
                          item: _offers[index],
                        ),
                        itemCount: _offers.length,
                      ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _requests.isEmpty
                    ? Center(
                        child: Text(
                          'No Requests Yet',
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
                          item: _requests[index],
                        ),
                        itemCount: _requests.length,
                      ),
          ],
        ),
      ),
    );
  }
}
