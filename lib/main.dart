import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fullscreen/fullscreen.dart';

void main() {
  var applicationBarText = Text('My Application');
  var topBar = AppBar(title: applicationBarText);
  var textContents = Text('Hello Oamk Student!');
  var centerText = Center(child: textContents);
  var coreUi = Scaffold(appBar: topBar, body: centerText);
  var myApp = MaterialApp(home: coreUi);

  runApp(myApp);
}
