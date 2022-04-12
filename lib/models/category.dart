import 'package:flutter/material.dart';

class Category {
  final String id, title;
  final List<String> itemsIds;

  Category({
    @required this.title,
    @required this.id,
    @required this.itemsIds,
  });
}
