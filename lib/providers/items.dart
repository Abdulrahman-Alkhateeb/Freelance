import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freelance/models/item.dart';
import 'package:freelance/utils/server_info.dart';
import 'package:http/http.dart' as http;

class Items with ChangeNotifier {
  List<Item> _items = [], _userItems = [];

  Future<bool> getUserItems({
    @required String userId,
  }) async {
    try {
      _userItems.clear();

      var response = await http.post(
        ServerInfo.USER_ITEMS,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "userId": userId,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> _data = json.decode(response.body);
        List<dynamic> _loadedItems = _data["items"];

        _loadedItems.forEach((item) {
          int _itemTypeIndex = int.parse(item["itemType"].toString());

          _userItems.add(
            Item(
              id: item["_id"],
              title: item["title"],
              description: item["description"],
              image: item["image"],
              catId: item["catId"],
              type: ItemType.values[_itemTypeIndex],
              ownerId: item["ownerId"],
              ownerPhoneNumber: int.parse(item["ownerPhoneNumber"]),
              ownerName: item["ownerName"],
            ),
          );
        });
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  List<Item> get userItems {
    return [..._userItems];
  }

  Future<bool> getItems({
    @required String catId,
  }) async {
    try {
      _items.clear();
      var response = await http.get("${ServerInfo.ITEMS}/$catId");
      if (response.statusCode == 200) {
        Map<String, dynamic> _data = json.decode(response.body);
        List<dynamic> _loadedItems = _data["items"];

        _loadedItems.forEach((item) {
          int _itemTypeIndex = int.parse(item["itemType"].toString());

          _items.add(
            Item(
              id: item["_id"],
              title: item["title"],
              description: item["description"],
              image: item["image"],
              catId: item["catId"],
              type: ItemType.values[_itemTypeIndex],
              ownerId: item["ownerId"],
              ownerPhoneNumber: int.parse(item["ownerPhoneNumber"]),
              ownerName: item["ownerName"],
            ),
          );
        });
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  List<Item> offers() {
    return [
      ..._items.where(
        (item) => item.type == ItemType.Offer,
      )
    ];
  }

  List<Item> requests() {
    return [
      ..._items.where(
        (item) => item.type == ItemType.Request,
      )
    ];
  }

  Future<bool> addItem({
    @required Item item,
    @required String imagePath,
  }) async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(ServerInfo.CREATE_ITEM),
      );
      request.fields.addAll({
        "title": item.title,
        "description": item.description,
        "catId": item.catId,
        "itemType": item.type.index.toString(),
        "ownerId": item.ownerId,
      });
      http.MultipartFile _image = await http.MultipartFile.fromPath(
        "image",
        imagePath,
      );

      request.files.add(_image);

      request.headers.addAll({
        "Content-Type": "multipart/form-data",
      });

      var response = await request.send();

      if (response.statusCode == 200) {
        _items.add(item);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      throw e;
    }
  }

/*
  Future<bool> addVehicleAd({
    @required VehicleAd vehicleAd,
  }) async {
    try {
      var request =
      http.MultipartRequest('POST', Uri.parse(ServerInfo.InsertAd));
      request.fields.addAll(vehicleAd.toMap());
      request.fields.addAll({
        'color': AppLists.colors['${vehicleAd.color}'][0].index.toString(),
      });
      request.files.add(await http.MultipartFile.fromPath(
        'adGallery',
        vehicleAd.image,
      ));

      List<String> _imagesPaths =
      vehicleAd.gallery.where((path) => path != null).toList();

      Future.wait(
        _imagesPaths.map(
              (imagePath) async {
            request.files.add(
              await http.MultipartFile.fromPath(
                'adGallery',
                imagePath,
              ),
            );
          },
        ),
      ).then((value) async {
        var response = await request.send();
        if (response.statusCode == 201)
          notifyListeners();
        else
          return false;
      });
    } catch (e) {
      return false;
    }

    return true;
  }
  */

  Future<bool> deleteItem({
    @required String itemId,
  }) async {
    var response = await http.delete("${ServerInfo.ITEMS}/$itemId");
    if (response.statusCode == 200) {
      _items.removeWhere((item) => item.id == itemId);
      notifyListeners();
      return true;
    }

    return false;
  }
}
