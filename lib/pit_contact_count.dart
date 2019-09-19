import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pit_contact_count/model.dart';

class PitContactCount {
  static const MethodChannel _channel = const MethodChannel('pit_contact_count');

  static Future<int> getContactCount() async {
    final int count = await _channel.invokeMethod('getContactCount');
    return count;
  }

  static Future<String> getContactStringJson(ContactInfo type) async {
    String param = getContactInfoString(type);
    String result = await _channel.invokeMethod("getContactStringJson", {"param": param});
    return result;
  }

  static Future<List<ContactModel>> getContactList(ContactInfo type) async {
    var result;
    switch(type){
      case ContactInfo.contactOnly:
        result = await _channel.invokeMethod("getListContactOnly");
        break;
      case ContactInfo.allData:
        result = await _channel.invokeMethod("getListAllContact");
        break;
      case ContactInfo.contactEmailAndAddress:
        result = await _channel.invokeMethod("getListAddressEmail");
        break;
    }
    List<ContactModel> finalResult = [];

    for (var item in result) {
      finalResult.add(ContactModel.fromJson(Map<String, dynamic>.from(item)));
    }
    return finalResult;
  }
}

enum ContactInfo { contactOnly, allData, contactEmailAndAddress }

String getContactInfoString(ContactInfo contactInfo) {
  String getContactInfoString = "";
  switch (contactInfo) {
    case ContactInfo.contactOnly:
      getContactInfoString = "CONTACT_ONLY";
      break;
    case ContactInfo.allData:
      getContactInfoString = "ALL_DATA";
      break;
    case ContactInfo.contactEmailAndAddress:
      getContactInfoString = "CONTACT_EMAIL_ADDRESS";
      break;
  }
  return getContactInfoString;
}
