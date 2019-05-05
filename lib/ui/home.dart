import 'package:flutter/material.dart';
import 'package:flutter_notes_app/ui/notes_screen.dart';

///Created on Android Studio Canary Version
///User: Gagandeep
///Date: 05-05-2019
///Time: 10:28
///Project Name: flutter_notes_app

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do App"),
        backgroundColor: Colors.black38,
        centerTitle: true,
      ),
      body: NotesScreen() ,
    );
  }
}
