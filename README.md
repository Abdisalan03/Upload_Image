# StreamFirebase

A Flutter widget that allows you to add data to Firebase Firestore and upload an image to Firebase Storage.

## Usage

To use the `StreamFirebase` widget, follow these steps:

1. Add the required dependencies to your `pubspec.yaml` file:

    ```yaml
    dependencies:
      cloud_firestore: ^2.5.3
      firebase_storage: ^10.2.0
      flutter:
        sdk: flutter
      image_picker: ^0.8.4+4
    ```

2. Import the necessary libraries:

    ```dart
    import 'dart:convert';
    import 'dart:io';
    import 'dart:typed_data';

    import 'package:cloud_firestore/cloud_firestore.dart';
    import 'package:firebase_storage/firebase_storage.dart';
    import 'package:flutter/material.dart';
    import 'package:image_picker/image_picker.dart';
    ```

3. Create a new instance of the `StreamFirebase` widget:

    ```dart
    StreamFirebase()
    ```

4. Use the widget within your Flutter app:

    ```dart
    MaterialApp(
      home: Scaffold(
        body: StreamFirebase(),
      ),
    )
    ```

## Example

Here's an example of how you can use the `StreamFirebase` widget:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: StreamFirebase(),
      ),
    );
  }
}

## Image

![Alt Text](/lib/image.jpg)
