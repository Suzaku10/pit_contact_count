package com.padimas.pitcontactcount;

import android.database.Cursor;
import android.provider.ContactsContract;
import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** PitContactCountPlugin */
public class PitContactCountPlugin implements MethodCallHandler {
  public PitContactCountPlugin(Registrar registrar) {
    this.registrar = registrar;
  }

  Registrar registrar;
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "pit_contact_count");
    channel.setMethodCallHandler(new PitContactCountPlugin(registrar));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getContactCount")) {
      int count = getContactCount();
      result.success(count);
    } else {
      result.notImplemented();
    }
  }

  public int getContactCount(){
    int count = 0;
    try {
      Cursor cursor =  registrar.activity().managedQuery(ContactsContract.Contacts.CONTENT_URI, null, null, null, null);

      count = cursor.getCount();
    }
    catch(Exception e) {
      Log.d("Error", "getGalleryCount:" + e.getLocalizedMessage());
      count = -1;
    }
    return count;
  }
}
