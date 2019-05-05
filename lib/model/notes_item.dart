import 'package:flutter/material.dart';

///Created on Android Studio Canary Version
///User: Gagandeep
///Date: 05-05-2019
///Time: 10:43
///Project Name: flutter_notes_app

class NotesItem extends StatelessWidget {
  String _itemName;
  String _dateCreated;
  int _id;

  NotesItem(this._itemName, this._dateCreated);

  NotesItem.map(dynamic obj) {
    //to make a map from sent data
    this._id = obj['id'];
    this._itemName = obj['itemName'];
    this._dateCreated = obj['dateCreated'];
  }

  String get itemName => _itemName;

  String get dateCreated => _dateCreated;

  int get id => _id;

  Map<String, dynamic> toMap() {
    //to make a map of current object
    var map = Map<String, dynamic>();
    map['itemName'] = _itemName;
    map['dateCreated'] = _dateCreated;

    if (_id != null) map['itemId'] = _id;
    return map;
  }

  NotesItem.fromMap(Map<String, dynamic> map) {
    //to create an object from map
    this._itemName = map['itemName'];
    this._id = map['id'];
    this._dateCreated = map['dateCreated'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: EdgeInsets.all(8.0),
      child:
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Text(
          "$_itemName",
          style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16.9, color: Colors.white),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.0),
          child: Text("Created On: $_dateCreated",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.6,
              fontStyle: FontStyle.italic)),
        )
      ],
      )
    );
  }
}
