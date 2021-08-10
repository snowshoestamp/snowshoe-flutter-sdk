SnowShoe Flutter SDK

## Features

Provides a widget with a listener that detects contact with a SnowShoe tap or stamp device.
It will authenticate the device against the SnowShoe API and return a success or failure response.

## Getting started

### Step 1: Get the library

Add the library to your project's pubspec.yaml file (then update your deps with `dart pub get`):

```
dependencies:
  snowshoe_sdk_flutter:
    git: https://github.com/snowshoestamp/snowshoe-flutter-sdk.git
```

### Step 2: Create a tappable page

In your app, use the `SnowShoeView` class to create a tappable area, then override the `onStampResult` method with
custom logic, to handle the SnowShoe API response, that is appropriate for your app:

```dart
import 'package:flutter/material.dart';
import 'package:snowshoe_sdk_flutter/snowshoe_sdk_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'SnowShoe flutter sdk demo page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> implements OnStampListener {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.title)
        ),
        body: SnowShoeView.secondary(this, "YOUR_SNOWSHOE_API_KEY")
    );
  }

  @override
  void onStampRequestMade() {

  }

  @override
  void onStampResult(StampResult? result) {
    print(result?.toJson());
  }
}
```

### Step 3: Set your SnowShoe API key

When using the SnowShoeView, be sure to replace `YOUR_SNOWSHOE_API_KEY` with your actual SnowShoe API key.
For more information please see the [SnowShoe docs](https://snowshoe.readme.io/v3.0/docs). 
