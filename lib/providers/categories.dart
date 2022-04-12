import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:freelance/models/category.dart';
import 'package:freelance/utils/server_info.dart';
import 'package:http/http.dart ' as http;

class Categories with ChangeNotifier {
  List<Category> _categories = [], _allCategories = [];

  Future<List<Category>> categories() async {
    await _getCategories();
    return [..._categories];
  }

  Future<List<Category>> allCategories() async {
    await _getAllCategories();
    return [..._allCategories];
  }

  Future<bool> _getCategories() async {
    _categories.clear();
    try {
      var response = await http.get("${ServerInfo.CATEGORIES}/false");
      if (response.statusCode == 200) {
        Map<String, dynamic> _data = json.decode(response.body);
        List<dynamic> _cats = _data["categories"];

        _cats.forEach((cat) {
          _categories.add(
            Category(
              title: cat["name"],
              itemsIds: (cat["items"] as List)
                  ?.map((itemId) => itemId as String)
                  ?.toList(),
              id: cat["_id"],
            ),
          );
        });
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> _getAllCategories() async {
    _allCategories.clear();
    try {
      var response = await http.get("${ServerInfo.CATEGORIES}/true");
      if (response.statusCode == 200) {
        Map<String, dynamic> _data = json.decode(response.body);
        List<dynamic> _cats = _data["categories"];

        _cats.forEach((cat) {
          _allCategories.add(
            Category(
              title: cat["name"],
              itemsIds: (cat["items"] as List)
                  ?.map((itemId) => itemId as String)
                  ?.toList(),
              id: cat["_id"],
            ),
          );
        });
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> addCat({
    @required String title,
  }) async {
    try {
      var response = await http.post(
        ServerInfo.CATEGORIES,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": title,
        }),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> _data = json.decode(response.body);

        _categories.add(
          Category(
            title: title,
            itemsIds: [],
            id: _data["catId"],
          ),
        );
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
