# PIT Contact Count

Use this Plugin for count a contact

*Note*: This plugin is still under development, and some Components might not be available yet or still has so many bugs.

## Installation

First, add `pit_contact_count` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

```
pit_contact_count: ^0.1.0
```

## Important

this plugin depends on other plugins, you must have a permission to use this plugin, you can use `pit_permission` plugin or other permission plugin.

You must add this permission in AndroidManifest.xml for Android

```
for read Contact = <uses-permission android:name="android.permission.READ_CONTACTS"/>
```

And you must add this on info.plist for IOS

### For read contact
```
 <key>NSContactsUsageDescription</key>
 <string>${PRODUCT_NAME} Need To Access Your Contact</string>
```

## Example for Get Contact Count
```
   int contactCount = await PitContactCount.getContactCount();
```

## Example for Get ContactList
```
    List<dynamic> result = await PitContactCount.getContactList();
```
