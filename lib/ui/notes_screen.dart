import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {_showFormDialog();},
      child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showFormDialog() {}
}

