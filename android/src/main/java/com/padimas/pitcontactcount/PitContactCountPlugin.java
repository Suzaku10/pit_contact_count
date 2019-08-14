package com.padimas.pitcontactcount;

import android.database.Cursor;
import android.provider.ContactsContract;
import android.util.Log;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * PitContactCountPlugin
 */
public class PitContactCountPlugin implements MethodCallHandler {
    public PitContactCountPlugin(Registrar registrar) {
        this.registrar = registrar;
    }

    Registrar registrar;

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "pit_contact_count");
        channel.setMethodCallHandler(new PitContactCountPlugin(registrar));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getContactCount")) {
            int count = getContactCount();
            result.success(count);
        } else if (call.method.equals("getContactList")) {
            List<Map<String, Object>> res = getContactList();
            result.success(res);
        } else {
            result.notImplemented();
        }
    }

    public int getContactCount() {
        int count = 0;
        try {
            Cursor cursor = registrar.activity().managedQuery(ContactsContract.Contacts.CONTENT_URI, null, null, null, null);

            count = cursor.getCount();
        } catch (Exception e) {
            Log.d("Error", "getGalleryCount:" + e.getLocalizedMessage());
            count = -1;
        }
        return count;
    }

    public List<Map<String, Object>> getContactList() {
        List<Map<String, Object>> res = new ArrayList<>();
        String[] projections = {
                ContactsContract.CommonDataKinds.Phone.NUMBER,
                ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME};
        try {
            Cursor cursor = registrar.context().getContentResolver().query(
                    ContactsContract.CommonDataKinds.Phone.CONTENT_URI, projections, null,
                    null, null);
            if (cursor != null) {
                for (cursor.moveToFirst(); !cursor.isAfterLast(); cursor.moveToNext()) {
                    Map<String, Object> result = new HashMap<>();
                    for (int i = 0; i < projections.length; i++) {
                        String key = projections[i].contains(ContactsContract.CommonDataKinds.Phone.NUMBER)
                                ? "phoneNumber"
                                : "displayName";
                        result.put(key, cursor.getString(i));
                    }
                    res.add(result);
                }
                cursor.close();
            }
        } catch (Exception e) {
            Log.d("Error", "getGalleryCount:" + e.getLocalizedMessage());
        }
        return res;
    }
}
