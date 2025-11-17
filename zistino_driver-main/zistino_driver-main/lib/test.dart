/*
import 'package:flutter/material.dart';
import 'package:background_fetch/background_fetch.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _counter = 0;

  @override
  void initState() {
    super.initState();
    initBackgroundFetch();
  }

  void initBackgroundFetch() async {
    // Configure the background fetch task
    BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        startOnBoot: true,
      ),
      backgroundTaskEntryPoint,
    ).then((int status) {
      print('[BackgroundFetch] configure success: $status');
    }).catchError((e) {
      print('[BackgroundFetch] configure error: $e');
    });
  }

  static void backgroundTaskEntryPoint() {
    // This is the headless task entry point that runs when the app is not in the foreground
    print('[BackgroundFetch] headless task running');
    backgroundTask();
  }

  static void backgroundTask() {
    // This is the background fetch task that runs every 15 minutes
    print('[BackgroundFetch] task running');
    // You can perform your background task here, such as fetching data from a server, updating a database, etc.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Background Fetch Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Background Fetch Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Counter: $_counter'),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _counter++;
                  });
                },
                child: Text('Increment Counter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
