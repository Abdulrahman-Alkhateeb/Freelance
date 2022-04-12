import 'package:flutter/material.dart';

enum ItemType {
  Offer,
  Request,
}

class Item {
  final int ownerPhoneNumber;
  final String id, catId, title, image, ownerId, ownerName, description;
  final ItemType type;

  Item({
    this.id,
    @required this.title,
    @required this.image,
    @required this.ownerId,
    @required this.description,
    @required this.type,
    @required this.catId,
    @required this.ownerPhoneNumber,
    @required this.ownerName,
  });
}
