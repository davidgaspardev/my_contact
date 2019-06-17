import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MainActivity.appName,
      home: MainActivity(),
    );
  }
}

class MainActivity extends StatefulWidget {

  static final String appName = "My Contacts";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainActivity();
  }

}

class _MainActivity extends State<MainActivity> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(MainActivity.appName),
        backgroundColor: Colors.red,
        centerTitle: true
      ),
      backgroundColor: Colors.white,
    );
  }



}
