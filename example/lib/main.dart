import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pit_contact_count/pit_contact_count.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _contactCount = 0;

  @override
  void initState() {
    super.initState();
    getContactCount();
  }

  Future<void> getContactCount() async {
    int contactCount;

    try {
      contactCount = await PitContactCount.getContactCount();
    } on PlatformException {
      contactCount = -1;
    }

    if (!mounted) return;

    setState(() {
      _contactCount = contactCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PitContactCount Plugin example app'),
        ),
        body: Center(
          child: Text('Total Contact in Your Phone: $_contactCount\n'),
        ),
      ),
    );
  }
}
