import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:freelance/models/item.dart';
import 'package:freelance/models/user.dart';
import 'package:freelance/providers/info.dart';
import 'package:freelance/providers/items.dart';
import 'package:freelance/screens/content_screen.dart';
import 'package:freelance/utils/server_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

enum LaunchMode {
  Call,
  WhatsApp,
}

class ContentCard extends StatefulWidget {
  final Item item;
  final BuildContext context;

  const ContentCard({
    @required this.context,
    @required this.item,
  });

  @override
  _ContentCardState createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  User _user;
  bool _firstTime = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _user = Provider.of<Info>(
        context,
        listen: false,
      ).user;
      _firstTime = false;
    }
  }

  Future<void> _showInfo() async {
    String result = await showModalBottomSheet(
      context: widget.context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height / 2,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Title:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.item.title,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Owner Name:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.item.ownerName,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Phone Number:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '0' + widget.item.ownerPhoneNumber.toString(),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    widget.item.description,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(500),
                    ),
                    onPressed: () {
                      _launchURL(
                        url: _user.phoneNumber.toString(),
                        launchMode: LaunchMode.Call,
                      );
                    },
                    color: Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FlutterIcons.phone_ant,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Call",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(500),
                    ),
                    onPressed: () {
                      _launchURL(
                        url: _user.phoneNumber.toString(),
                        launchMode: LaunchMode.WhatsApp,
                      );
                    },
                    color: Colors.lightGreen,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FlutterIcons.whatsapp_faw,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Whatsapp",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_user.id == widget.item.ownerId)
                  SizedBox(
                    height: 20,
                  ),
                if (_user.id == widget.item.ownerId)
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(500),
                      ),
                      onPressed: () async {
                        bool result = await Provider.of<Items>(
                          context,
                          listen: false,
                        ).deleteItem(
                          itemId: widget.item.id,
                        );
                        if (result) {
                          Navigator.of(context).pop("refresh");
                        }
                      },
                      color: Colors.red,
                      child: Text(
                        "Delete",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    if (result == "refresh") {
      setState(() {
        ContentScreen.firstTime = true;
      });
    }
  }

  Future<void> _launchURL({
    @required String url,
    @required LaunchMode launchMode,
  }) async {
    String _url;
    switch (launchMode) {
      case LaunchMode.Call:
        _url = 'tel:+963$url';
        break;
      case LaunchMode.WhatsApp:
        _url = _launchWhatsApp(
          phone: int.parse(url),
          message: widget.item.type == ItemType.Offer
              ? 'مرحبا أريد الاستفسار عن عرضك في تطبيق فريلانس'
              : 'مرحبا أريد الاستفسار عن طلبك في تطبيق فريلانس',
        );
        break;
    }
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  String _launchWhatsApp({
    @required int phone,
    @required String message,
  }) {
    if (Platform.isAndroid) {
      return "https://wa.me/+963$phone/?text=${Uri.parse(message)}";
    } else {
      return "https://api.whatsapp.com/send?phone=+963$phone=${Uri.parse(message)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showInfo,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Image(
              image: NetworkImage(
                "${ServerInfo.SERVER}/${widget.item.image.replaceAll("\\", "/")}",
              ),
              height: 250,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black.withOpacity(.5),
            ),
            Center(
              child: Text(
                widget.item.title,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Colors.lightGreen,
            width: 2,
          ),
        ),
      ),
    );
  }
}
