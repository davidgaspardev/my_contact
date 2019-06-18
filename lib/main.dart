import 'dart:io';
import 'package:my_contacts/helpers/contact_helper.dart';
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
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = List();

  @override
  initState() {
    super.initState();

    // Passing contacts from database to variable local
    helper.getContacts().then((contactsList) {
      setState(() {
        contacts = contactsList;
        contacts.add(Contact.fromMap({ "name": "David", "email": "davidgaspar.dev@gmail.com", "phone": "48984596682"}));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Text(MainActivity.appName),
          backgroundColor: Colors.red,
          centerTitle: true),
      backgroundColor: Colors.white,
      body: ListView.builder(
          padding: EdgeInsets.only(right: 10.0, left: 10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: contacts[index].img != null
                            ? FileImage(File(contacts[index].img))
                            : AssetImage("images/person.png"))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(contacts[index].name ?? "",
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold)),
                    Text(contacts[index].email ?? "",
                        style: TextStyle(fontSize: 18.0)),
                    Text(contacts[index].phone ?? "",
                        style: TextStyle(fontSize: 18.0))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
