import 'package:flutter/material.dart';
import 'package:flutter_notes_app/model/notes_item.dart';
import 'package:flutter_notes_app/util/database_helper.dart';

///Created on Android Studio Canary Version
///User: Gagandeep
///Date: 05-05-2019
///Time: 14:42
///Project Name: flutter_notes_app

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _notesInputController = TextEditingController();
  var dbClient = DatabaseHelper();
  List<NotesItem> _notesList = <NotesItem>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
          future: _readAllNotes(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData)
              return Text("");
            else {
              List _item = snapshot.data;
              int size = _item.length;
              return ListView.builder(
                itemCount: size,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text("${_item[index]['itemName']}"),
                      onLongPress: () {},
                      trailing: Listener(
                        key: Key(_item[index]['itemName']),
                        child: Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                        onPointerDown: (pointerEvent) => debugPrint(""),
                      ),
                    ),
                  );
                },
              );
            }
          }),
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
        builder: (_) {
          return alert;
        });
  }

  void _saveData(String text) async {
    if (text != null && text != "") {
      NotesItem notes = new NotesItem(text, DateTime.now().toIso8601String());
      int savedItdId = await dbClient.saveItem(notes);
      NotesItem addedItem = await dbClient.getNote(savedItdId);
      setState(() {
        print("${addedItem.toString()}");
//        _notesList.insert(0, addedItem);
      });
      _notesInputController.text = "";
    }
    Navigator.pop(context);
  }

  Future<List> _readAllNotes() async {
    List items = await dbClient.getAllItems();
    return items;
  }
}
