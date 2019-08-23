import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pit_contact_count/model.dart';

class PitContactCount {
  static const MethodChannel _channel = const MethodChannel('pit_contact_count');

  static Future<int> getContactCount() async {
    final int count = await _channel.invokeMethod('getContactCount');
    return count;
  }

  static Future<List<ContactModel>> getContactList() async {
    var result = await _channel.invokeMethod("getContactList");
    List<ContactModel> finalResult = [];

    for (var item in result) {
      finalResult.add(ContactModel.fromJson(Map<String, dynamic>.from(item)));
    }

    return finalResult;
  }
}
