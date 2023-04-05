import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final BehaviorSubject<DateTime> subject;
  late final Stream<String> streamsOfStrings;

  @override
  void initState() {
    super.initState();
    subject = BehaviorSubject<DateTime>();
    streamsOfStrings = subject.switchMap((dateTime) => Stream.periodic(
        Duration(seconds: 1),
        (count) => 'Stream count = $count, datetime = $dateTime'));
  }

  @override
  void dispose() {
    subject.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
        ),
        body: Column(
          children: [
            StreamBuilder<String>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final string = snapshot.requireData;
                  return Text(string);
                } else {
                  return const Text("Waiting for the button to be pressed");
                }
              },
              stream: streamsOfStrings,
            ),
            TextButton(
                onPressed: () {
                  subject.add(DateTime.now());
                },
                child: const Text("Start the stream")),
          ],
        ));
  }
}
