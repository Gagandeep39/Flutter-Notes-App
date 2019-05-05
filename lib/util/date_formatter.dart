import 'package:intl/intl.dart';

///Created on Android Studio Canary Version
///User: Gagandeep
///Date: 05-05-2019
///Time: 15:51
///Project Name: flutter_notes_app

String dateFormatted() {
  var now = DateTime.now();
  var formatter = DateFormat("EEE, MMM dd, 'y");
  String formatted = formatter.format(now);
  return formatted;
}
