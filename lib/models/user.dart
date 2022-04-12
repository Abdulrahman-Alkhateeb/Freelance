import 'package:flutter/cupertino.dart';

class User {
  final int phoneNumber;
  final String id, name;

  User({
    @required this.id,
    @required this.phoneNumber,
    @required this.name,
  });
}
