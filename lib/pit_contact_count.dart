import 'dart:async';

import 'package:flutter/services.dart';

class PitContactCount {
  static const MethodChannel _channel =
      const MethodChannel('pit_contact_count');

  static Future<int> getContactCount() async {
    final int count = await _channel.invokeMethod('getContactCount');
    return count;
  }

  static Future<List<dynamic>> getContactList() async {
    var result = await _channel.invokeMethod("getContactList");
    return result;
  }
}
