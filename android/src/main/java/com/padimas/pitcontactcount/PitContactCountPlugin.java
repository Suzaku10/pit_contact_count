package com.padimas.pitcontactcount;

import android.app.Activity;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.provider.ContactsContract;
import android.provider.MediaStore;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
        this.activity = registrar.activity();
        this.context = registrar.context();
    }

    Activity activity;
    Context context;

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "pit_contact_count");
        channel.setMethodCallHandler(new PitContactCountPlugin(registrar));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getContactCount")) {
            int count = getContactCount();
            result.success(count);
        } else if (call.method.equals("getListContactOnly")) {
            List<Map<String, Object>> res;
            try {
                res = getListContactOnly();
                result.success(res);
            } catch (Exception e) {
                e.printStackTrace();
                result.error("error", e.getLocalizedMessage(), e);
            }
        } else if (call.method.equals("getListAllContact")) {
            List<Map<String, Object>> res = null;
            try {
                res = getListAllContactInfo();
                result.success(res);
            } catch (Exception e) {
                e.printStackTrace();
                result.error("error", e.getLocalizedMessage(), e);
            }
        } else if (call.method.equals("getListAddressEmail")) {
            List<Map<String, Object>> res = null;
            try {
                res = getListContactEmailAndAddress();
                result.success(res);
            } catch (Exception e) {
                e.printStackTrace();
                result.error("error", e.getLocalizedMessage(), e);
            }
        } else if (call.method.equals("getContactStringJson")) {
            String param = call.argument("param");
            try {
                String res = "";
                List<Map<String, Object>> contactResult;
                switch (param) {
                    case "CONTACT_ONLY":
                        contactResult = getListContactOnly();
                        res = getContactStringJson(contactResult);
                        break;
                    case "ALL_DATA":
                        contactResult = getListAllContactInfo();
                        res = getContactStringJson(contactResult);
                        break;
                    case "CONTACT_EMAIL_ADDRESS":
                        contactResult = getListContactEmailAndAddress();
                        res = getContactStringJson(contactResult);
                        break;
                }
                result.success(res);
            } catch (Exception e) {
                e.printStackTrace();
                result.error("error", e.getLocalizedMessage(), e);
            }
        } else {
            result.notImplemented();
        }
    }

    public int getContactCount() {
        int count = 0;
        try {
            Cursor cursor = activity.getContentResolver().query(ContactsContract.Contacts.CONTENT_URI, null, null, null, null);

            count = cursor.getCount();
            cursor.close();
        } catch (Exception e) {
            count = -1;
        }
        return count;
    }

    public List<Map<String, Object>> getListContactOnly() throws Exception {
        List<Map<String, Object>> res = new ArrayList<>();
        String[] projections = {
                ContactsContract.Data.CONTACT_ID,
                ContactsContract.CommonDataKinds.Phone.NUMBER,
                ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME
        };
        Cursor cursor = context.getContentResolver().query(
                ContactsContract.CommonDataKinds.Phone.CONTENT_URI, projections, null,
                null, null);

        if (cursor != null) {
            for (cursor.moveToFirst(); !cursor.isAfterLast(); cursor.moveToNext()) {
                Map<String, Object> result = new HashMap<>();
                for (int i = 0; i < projections.length; i++) {
                    result.put(projections[i], cursor.getString(i));
                }
                res.add(result);
            }
            cursor.close();
        }
        return res;
    }

    public List<Map<String, Object>> getListAllContactInfo() throws Exception {
        List<Map<String, Object>> res = new ArrayList<>();
        String[] projections = {
                ContactsContract.Data.CONTACT_ID,
                ContactsContract.CommonDataKinds.Phone.NUMBER,
                ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME
        };

        Cursor cursor = context.getContentResolver().query(
                ContactsContract.CommonDataKinds.Phone.CONTENT_URI, projections, null,
                null, null);

        if (cursor != null) {
            for (cursor.moveToFirst(); !cursor.isAfterLast(); cursor.moveToNext()) {
                final String[] emailProjection = new String[]{ContactsContract.CommonDataKinds.Email.ADDRESS};
                final String[] addressProjection = new String[]{ContactsContract.CommonDataKinds.StructuredPostal.FORMATTED_ADDRESS, ContactsContract.CommonDataKinds.StructuredPostal.STREET, ContactsContract.CommonDataKinds.StructuredPostal.CITY, ContactsContract.CommonDataKinds.StructuredPostal.REGION, ContactsContract.CommonDataKinds.StructuredPostal.COUNTRY, ContactsContract.CommonDataKinds.StructuredPostal.POSTCODE};
                final String[] organizationProjection = new String[]{ContactsContract.CommonDataKinds.Organization.COMPANY, ContactsContract.CommonDataKinds.Organization.DEPARTMENT, ContactsContract.CommonDataKinds.Organization.TITLE, ContactsContract.CommonDataKinds.Organization.OFFICE_LOCATION};
                final String[] relationProjection = new String[]{ContactsContract.CommonDataKinds.Relation.NAME, ContactsContract.CommonDataKinds.Relation.TYPE};
                final String[] noteProjection = new String[]{ContactsContract.CommonDataKinds.Note.NOTE};
                final String[] eventProjection = new String[]{ContactsContract.CommonDataKinds.Event.START_DATE, ContactsContract.CommonDataKinds.Event.TYPE};
                final String[] websiteProjection = new String[]{ContactsContract.CommonDataKinds.Website.URL, ContactsContract.CommonDataKinds.Website.TYPE};
                final String[] cursorQuery = new String[]{String.valueOf(cursor.getString(0))};

                final Cursor email = context.getContentResolver().query(
                        ContactsContract.CommonDataKinds.Email.CONTENT_URI,
                        emailProjection,
                        ContactsContract.Data.CONTACT_ID + "=?",
                        cursorQuery,
                        null);

                final Cursor address = context.getContentResolver().query(
                        ContactsContract.CommonDataKinds.StructuredPostal.CONTENT_URI,
                        addressProjection,
                        ContactsContract.Data.CONTACT_ID + "=?",
                        cursorQuery,
                        null);

                final Cursor organization = context.getContentResolver().query(
                        ContactsContract.Data.CONTENT_URI,
                        organizationProjection,
                        ContactsContract.Data.CONTACT_ID + " = ? AND " + ContactsContract.Data.MIMETYPE + " = ?",
                        new String[]{String.valueOf(cursor.getString(0)), ContactsContract.CommonDataKinds.Organization.CONTENT_ITEM_TYPE},
                        null);

                final Cursor relation = context.getContentResolver().query(
                        ContactsContract.Data.CONTENT_URI,
                        relationProjection,
                        ContactsContract.Data.CONTACT_ID + " = ? AND " + ContactsContract.Data.MIMETYPE + " = ?",
                        new String[]{String.valueOf(cursor.getString(0)), ContactsContract.CommonDataKinds.Relation.CONTENT_ITEM_TYPE},
                        null);

                final Cursor note = context.getContentResolver().query(
                        ContactsContract.Data.CONTENT_URI,
                        noteProjection,
                        ContactsContract.Data.CONTACT_ID + " = ? AND " + ContactsContract.Data.MIMETYPE + " = ?",
                        new String[]{String.valueOf(cursor.getString(0)), ContactsContract.CommonDataKinds.Note.CONTENT_ITEM_TYPE},
                        null);

                final Cursor event = context.getContentResolver().query(
                        ContactsContract.Data.CONTENT_URI,
                        eventProjection,
                        ContactsContract.Data.CONTACT_ID + " = ? AND " + ContactsContract.Data.MIMETYPE + " = ?",
                        new String[]{String.valueOf(cursor.getString(0)), ContactsContract.CommonDataKinds.Event.CONTENT_ITEM_TYPE},
                        null);

                final Cursor website = context.getContentResolver().query(
                        ContactsContract.Data.CONTENT_URI,
                        eventProjection,
                        ContactsContract.Data.CONTACT_ID + " = ? AND " + ContactsContract.Data.MIMETYPE + " = ?",
                        new String[]{String.valueOf(cursor.getString(0)), ContactsContract.CommonDataKinds.Website.CONTENT_ITEM_TYPE},
                        null);

                Map<String, Object> result = new HashMap<>();
                for (int i = 0; i < projections.length; i++) {
                    result.put(projections[i], cursor.getString(i));
                }

                if (email != null) {
                    List<String> emailList = new ArrayList<>();
                    for (email.moveToFirst(); !email.isAfterLast(); email.moveToNext()) {
                        emailList.add(email.getString(0));
                    }
                    result.put("email", emailList);
                    email.close();
                }

                if (address != null) {
                    List<Map<String, Object>> addressList = new ArrayList<>();
                    for (address.moveToFirst(); !address.isAfterLast(); address.moveToNext()) {
                        Map<String, Object> addressResult = new HashMap<>();
                        for (int i = 0; i < addressProjection.length; i++) {
                            addressResult.put(addressProjection[i], address.getString(i));
                        }
                        addressList.add(addressResult);
                    }
                    result.put("address", addressList);
                    address.close();
                }

                if (organization.moveToFirst()) {
                    Map<String, Object> organizationResult = new HashMap<>();

                    for (int i = 0; i < organizationProjection.length; i++) {
                        organizationResult.put(organizationProjection[i], organization.getString(i));
                    }
                    result.put("organization", organizationResult);
                }

                if (relation != null) {
                    List<Map<String, Object>> relationList = new ArrayList<>();
                    for (relation.moveToFirst(); !relation.isAfterLast(); relation.moveToNext()) {
                        Map<String, Object> relationResult = new HashMap<>();
                        for (int i = 0; i < relationProjection.length; i++) {
                            relationResult.put(relationProjection[i], relation.getString(i));
                        }
                        relationList.add(relationResult);
                    }
                    result.put("relation", relationList);
                    relation.close();
                }

                if (event != null) {
                    List<Map<String, Object>> eventList = new ArrayList<>();
                    for (event.moveToFirst(); !event.isAfterLast(); event.moveToNext()) {
                        Map<String, Object> eventResult = new HashMap<>();
                        for (int i = 0; i < eventProjection.length; i++) {
                            if (eventProjection[i].equals(ContactsContract.CommonDataKinds.Event.START_DATE)) {
                                String dateString = event.getString(0);
                                if (dateString.startsWith("-")) {
                                    DateFormat df = new SimpleDateFormat("MM-d");
                                    Date date = df.parse(dateString.substring(2));
                                    eventResult.put(eventProjection[i], date.getTime() / 1000);
                                } else {
                                    DateFormat df = new SimpleDateFormat("yyyy-MM-d");
                                    Date date = df.parse(dateString);
                                    eventResult.put(eventProjection[i], date.getTime() / 1000);
                                }
                            } else {
                                eventResult.put(eventProjection[i], event.getInt(i));
                            }
                        }
                        eventList.add(eventResult);
                    }
                    result.put("event", eventList);
                    event.close();
                }

                if (website != null) {
                    List<Map<String, Object>> websiteList = new ArrayList<>();
                    for (website.moveToFirst(); !website.isAfterLast(); website.moveToNext()) {
                        Map<String, Object> websiteResult = new HashMap<>();
                        for (int i = 0; i < websiteProjection.length; i++) {
                            websiteResult.put(websiteProjection[i], website.getString(i));
                        }
                        websiteList.add(websiteResult);
                    }

                    result.put("website", websiteList);
                    website.close();
                }

                if (note.moveToFirst()) {
                    result.put("note", note.getString(0));
                }

                res.add(result);
                organization.close();
                note.close();
            }
            cursor.close();
        }
        return res;
    }

    public List<Map<String, Object>> getListContactEmailAndAddress() throws Exception {
        List<Map<String, Object>> res = new ArrayList<>();
        String[] projections = {
                ContactsContract.Data.CONTACT_ID,
                ContactsContract.CommonDataKinds.Phone.NUMBER,
                ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME
        };

        Cursor cursor = context.getContentResolver().query(
                ContactsContract.CommonDataKinds.Phone.CONTENT_URI, projections, null,
                null, null);

        if (cursor != null) {
            for (cursor.moveToFirst(); !cursor.isAfterLast(); cursor.moveToNext()) {
                final String[] emailProjection = new String[]{ContactsContract.CommonDataKinds.Email.ADDRESS};
                final String[] addressProjection = new String[]{ContactsContract.CommonDataKinds.StructuredPostal.FORMATTED_ADDRESS, ContactsContract.CommonDataKinds.StructuredPostal.STREET, ContactsContract.CommonDataKinds.StructuredPostal.CITY, ContactsContract.CommonDataKinds.StructuredPostal.REGION, ContactsContract.CommonDataKinds.StructuredPostal.COUNTRY, ContactsContract.CommonDataKinds.StructuredPostal.POSTCODE};
                final String[] cursorQuery = new String[]{String.valueOf(cursor.getString(0))};

                final Cursor email = context.getContentResolver().query(
                        ContactsContract.CommonDataKinds.Email.CONTENT_URI,
                        emailProjection,
                        ContactsContract.Data.CONTACT_ID + "=?",
                        cursorQuery,
                        null);

                final Cursor address = context.getContentResolver().query(
                        ContactsContract.CommonDataKinds.StructuredPostal.CONTENT_URI,
                        addressProjection,
                        ContactsContract.Data.CONTACT_ID + "=?",
                        cursorQuery,
                        null);

                Map<String, Object> result = new HashMap<>();
                for (int i = 0; i < projections.length; i++) {
                    result.put(projections[i], cursor.getString(i));
                }

                if (email != null) {
                    List<String> emailList = new ArrayList<>();
                    for (email.moveToFirst(); !email.isAfterLast(); email.moveToNext()) {
                        emailList.add(email.getString(0));
                    }
                    result.put("email", emailList);
                    email.close();
                }

                if (address != null) {
                    List<Map<String, Object>> addressList = new ArrayList<>();
                    for (address.moveToFirst(); !address.isAfterLast(); address.moveToNext()) {
                        Map<String, Object> addressResult = new HashMap<>();
                        for (int i = 0; i < addressProjection.length; i++) {
                            addressResult.put(addressProjection[i], address.getString(i));
                        }
                        addressList.add(addressResult);
                    }
                    result.put("address", addressList);
                    address.close();
                }

                res.add(result);
            }
            cursor.close();
        }

        return res;
    }

    public String getContactStringJson(List<Map<String, Object>> contact) {
        GsonBuilder gsonMapBuilder = new GsonBuilder();

        Gson gsonObject = gsonMapBuilder.create();

        String JSONObject = gsonObject.toJson(contact);

        return JSONObject;
    }


}
