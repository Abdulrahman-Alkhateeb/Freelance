import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:freelance/models/user.dart';
import 'package:freelance/utils/server_info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Info with ChangeNotifier {
  User _user;
  String _token;

  User get user {
    return _user;
  }

  void setUser({
    @required User user,
  }) {
    _user = user;
  }

  Future<bool> token() async {
    final _prefs = await SharedPreferences.getInstance();
    _token = _prefs.getString("token");
    return _token != null;
  }

  Future<bool> login({
    @required String username,
    @required String password,
  }) async {
    try {
      var response = await http.post(
        ServerInfo.LOGIN,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> _data = json.decode(response.body);

        Map<String, dynamic> _userData = _data["user"];
        _user = User(
          id: _userData["_id"],
          name: _userData["name"],
          phoneNumber: int.parse(_userData["phoneNumber"]),
        );
        final _prefs = await SharedPreferences.getInstance();
        _prefs.setString("token", _data["token"]);
        _prefs.setString('id', _userData["_id"]);
        _prefs.setString('name', _userData["name"]);
        _prefs.setInt('phoneNumber', int.parse(_userData["phoneNumber"]));
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> signup({
    @required String username,
    @required String password,
    @required String fullName,
    @required String phoneNumber,
  }) async {
    try {
      var response = await http.post(
        ServerInfo.SIGNUP,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "password": password,
          "name": fullName,
          "phoneNumber": phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
