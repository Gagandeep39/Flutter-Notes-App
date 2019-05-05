import 'package:flutter/material.dart';
import 'package:flutter_notes_app/model/notes_item.dart';
import 'package:flutter_notes_app/util/database_helper.dart';
import 'package:flutter_notes_app/util/date_formatter.dart';

///Created on Android Studio Canary Version
///User: Gagandeep
///Date: 05-05-2019
///Time: 10:32
///Project Name: flutter_notes_app

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _notesInputController = TextEditingController();
  final _updateNoteController = TextEditingController();
  var dbClient = DatabaseHelper();
  final List<NotesItem> _itemList = <NotesItem>[];

  @override
  void initState() {
    super.initState();
    _readAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(8.0),
              reverse: false,
              itemCount: _itemList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.white10,
                  child: ListTile(
                    //****************this is where the Item layout widget is returned***************//
                    title: _itemList[index],
                    onLongPress: () {
                      _updateData(_itemList[index].id, index);
                    },
                    trailing: new Listener(
                      key: new Key(_itemList[index].itemName),
                      child: new Icon(
                        Icons.remove_circle,
                        color: Colors.redAccent,
                      ),
                      onPointerDown: (pointerEvent) {
                        _deleteData(_itemList[index].id, index);
                      })));
              },
            ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog();
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showFormDialog() {
    var alert = AlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _notesInputController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Add note",
                hintText: "eg. Call Abby",
                icon: Icon(Icons.note_add)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        RaisedButton(
          onPressed: () {
            _saveData(_notesInputController.text);
          },
          child: Text("Save"),
          textColor: Colors.white,
          color: Colors.red,
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        )
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
  }

  void _saveData(String text) async {
    if (text != null && text != "") {
      NotesItem notes = new NotesItem(text, dateFormatted());
      int savedItdId = await dbClient.saveItem(notes);
      NotesItem addedItem = await dbClient.getNote(savedItdId);
      setState(() {
        _itemList.insert(_itemList.length, addedItem);
//        showSnackBar(context, "Inserted: ", text);
      });
      _notesInputController.text = "";
    }
    Navigator.pop(context);
  }

  _readAllNotes() async {
    List items = await dbClient.getAllItems();
    items.forEach((item) {
      setState(() {
        _itemList.add(NotesItem.map(item));
      });
    });
  }

  void _deleteData(int id, int index) async {
    String name = _itemList[index].itemName;
    await dbClient.deleteNote(id);
    setState(() {
      _itemList.removeAt(index);
//      showSnackBar(context, "Deleted: ", name);
    });
  }

  void showSnackBar(BuildContext contex, String operation, String name) {
    Scaffold.of(contex).showSnackBar(SnackBar(
      content: new Text('$operation $name'),
      duration: new Duration(seconds: 5),
      action: new SnackBarAction(
        label: 'Ok',
        onPressed: () {},
      ),
    ));
  }

  void _updateData(int id, int index) {
    var alert = AlertDialog(
      title: Text("Update item name"),
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              autofocus: true,
              controller: _updateNoteController,
              decoration: InputDecoration(
                icon: Icon(Icons.update),
                labelText: "Update Note",
                hintText: "eg. Buy a Book"),
            ),
          )
        ],
      ),
      actions: <Widget>[
        RaisedButton(
          onPressed: () {
            _updateDatabase(_updateNoteController.text, id, index);

            _updateNoteController.text = "";
            Navigator.pop(context);
          },
          child: Text("Update"),
          textColor: Colors.white,
          color: Colors.red,
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        )
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
  }

  void _updateDatabase(String text, int id, int index) async {
    NotesItem item = new NotesItem.fromMap(
      {"id": id, "itemName": "$text", "dateCreated": dateFormatted()});
    int resutl = await dbClient.updateNote(item);
    print("Result: $resutl $text");
    if (resutl > 0)
      setState(() {
        _itemList.clear();
        _readAllNotes();
      });
  }
}
