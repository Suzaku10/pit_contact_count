import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pit_contact_count/pit_contact_count.dart';
import 'package:pit_contact_count/model.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _contactCount = 0;
  List<ContactModel> result = [];
  String contactJson;

  @override
  void initState() {
    super.initState();
    getContactCount();
  }

  Future<void> getContactCount() async {
    int contactCount;
    List<ContactModel> _list = [];
    String _contactJson;

    try {
      contactCount = await PitContactCount.getContactCount();
      _contactJson = await PitContactCount.getContactStringJson(ContactInfo.allData);
      _list = await PitContactCount.getContactList(ContactInfo.allData);
    } on PlatformException {
      contactCount = -1;
    }

    if (!mounted) return;

    setState(() {
      _contactCount = contactCount;
      result = _list;
      contactJson = _contactJson;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('PitContactCount Plugin example app'),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Text('Total Contact in Your Phone: $_contactCount\nContact Json : ${contactJson}\nContact List : $result'),
            ),
          )),
    );
  }
}
