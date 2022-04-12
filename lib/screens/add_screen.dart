import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freelance/models/category.dart';
import 'package:freelance/models/item.dart';
import 'package:freelance/models/user.dart';
import 'package:freelance/providers/categories.dart';
import 'package:freelance/providers/info.dart';
import 'package:freelance/providers/items.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatefulWidget {
  static const String routeName = "Add";

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  ItemType _type;
  bool _firstTime = true, _isLoading = true;
  GlobalKey<FormState> _submitFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _addCatFormKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _title, _description, _catName;
  String _categoryValue;
  File _image;
  User _user;

  List<Category> _categories = [];
  final picker = ImagePicker();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      Map<String, dynamic> _data = ModalRoute.of(context).settings.arguments;
      _type = _data['type'];
      _user = Provider.of<Info>(
        context,
        listen: false,
      ).user;
      _getCats();

      _firstTime = false;
    }
  }

  Future<void> _getCats() async {
    _categories = await Provider.of<Categories>(
      context,
      listen: false,
    ).allCategories();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _showAddCat() async {
    var result = await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text("Add Category"),
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _addCatFormKey,
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Category Name',
                ),
                validator: (value) {
                  if (value.isEmpty) return "Please Enter Name";
                  return null;
                },
                onSaved: (newValue) => _catName = newValue,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              FlatButton(
                onPressed: _addCat,
                child: Text("Add"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
            ],
          ),
        ],
      ),
    );
    if (result == 'refresh')
      setState(() {
        _getCats();
      });
  }

  void _addCat() {
    if (_addCatFormKey.currentState.validate()) {
      _addCatFormKey.currentState.save();

      Provider.of<Categories>(
        context,
        listen: false,
      ).addCat(title: _catName);
      setState(() {});
      Navigator.of(context).pop('refresh');
    }
  }

  Future<void> _submit() async {
    if (_image != null) {
      if (_categoryValue != null) {
        if (_submitFormKey.currentState.validate()) {
          _submitFormKey.currentState.save();

          Item _item = Item(
            type: _type,
            catId: _categoryValue,
            ownerId: _user.id,
            ownerPhoneNumber: _user.phoneNumber,
            ownerName: _user.name,
            description: _description,
            title: _title,
            image: _image.path,
          );

          bool result = await Provider.of<Items>(
            context,
            listen: false,
          ).addItem(
            item: _item,
            imagePath: _image.path,
          );
          if (result)
            Navigator.of(context).pop('refresh');
          else
            print('asd');
        }
      } else {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.blue,
            content: Text(
              "Please Choose Category",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        );
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.blue,
          content: Text(
            "Please Choose Image",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          "Add ${_type == ItemType.Offer ? "Offer" : "Request"}",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: _submit,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _submitFormKey,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Title',
                        ),
                        validator: (value) {
                          if (value.isEmpty) return "Please Enter Title";
                          return null;
                        },
                        onSaved: (newValue) => _title = newValue,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Image',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          InkWell(
                            onTap: _getImage,
                            child: Container(
                              child: _image == null
                                  ? Center(
                                      child: Text(
                                        'Click To Choose Image',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  : Image.file(
                                      _image,
                                      fit: BoxFit.cover,
                                    ),
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.lightGreen,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownButton(
                            items: _categories
                                .map(
                                  (cat) => DropdownMenuItem(
                                    child: Text(
                                      cat.title,
                                    ),
                                    value: cat.id,
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _categoryValue = value;
                              });
                            },
                            value: _categoryValue,
                            hint: Text("Choose Category"),
                          ),
                          Container(
                            width: 150,
                            child: FlatButton(
                              onPressed: _showAddCat,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                                side: BorderSide(
                                  color: Colors.lightGreen,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                "Add Category",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        maxLines: 10,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                          labelText: 'Description',
                        ),
                        validator: (value) {
                          if (value.isEmpty) return "Please Enter Description";
                          return null;
                        },
                        onSaved: (newValue) => _description = newValue,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
