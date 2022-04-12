import 'package:flutter/material.dart';
import 'package:freelance/models/category.dart';
import 'package:freelance/screens/content_screen.dart';

class CategoryCard extends StatefulWidget {
  final Category category;

  const CategoryCard({
    @required this.category,
  });

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ContentScreen.firstTime = true;
        Navigator.of(context).pushNamed(
          ContentScreen.routeName,
          arguments: {
            'title': widget.category.title,
            'catId': widget.category.id,
          },
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            width: 2,
            color: Colors.lightGreen,
          ),
        ),
        child: Center(
          child: Text(
            widget.category.title,
            style: TextStyle(
              color: Colors.lightGreen,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
