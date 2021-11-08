import 'package:flutter/material.dart';
import 'package:snowshoe_sdk_flutter/snowshoe_sdk_flutter.dart';
import 'package:snowshoe_sdk_flutter/src/models/snow_shoe_result.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    var snowShoeView = SnowShoeView.secondary(
        this,
        "YOUR_SNOWSHOE_API_KEY"
    );
    snowShoeView.syncStampInfo();
    var scaffold = Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: snowShoeView// This trailing comma makes auto-formatting nicer for build methods.
    );
    //snowShoeView.syncStampInfo();
    return scaffold;
  }

  @override
  void onGetSerialResult(SnowShoeResult? result) {
    print(result?.toJson());
  }

  @override
  void onSyncCompleted(bool result) {
    print("Sync completed: $result");
  }
}
