# PIT Contact Count

Use this Plugin for count a contact

*Note*: This plugin is still under development, and some Components might not be available yet or still has so many bugs.

## Installation

First, add `pit_contact_count` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

```
pit_contact_count: ^0.1.2
```

## Important

*Note*: ^0.1.1+1 doesn't support for IOS

this plugin depends on other plugins, you must have a permission to use this plugin, you can use `pit_permission` plugin or other permission plugin.

You must add this permission in AndroidManifest.xml for Android

```
for read Contact = <uses-permission android:name="android.permission.READ_CONTACTS"/>
```

*Note* : ^0.1.2 added enum
## Enum
```
   enum ContactInfo { contactOnly, allData, contactEmailAndAddress }
```

## Example for Get Contact Count
```
   int contactCount = await PitContactCount.getContactCount();
```

## Example for Get ContactList
```
    List<ContactModel> result = await PitContactCount.getContactList(ContactInfo.contactOnly);
```

## Example for Get getContactStringJson
*Note*: support on ^0.1.2
```
   String result = await PitContactCount.getContactStringJson(ContactInfo.contactOnly);
```
