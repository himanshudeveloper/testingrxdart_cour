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

void testit() async {
  final stream1 = Stream.periodic(
      const Duration(seconds: 1), (count) => 'Stream 1, count = $count');
  final stream2 = Stream.periodic(
      const Duration(seconds: 1), (count) => 'Stream 2, count = $count');
  // final combined = Rx.combineLatest2(
  //     stream1, stream2, (one, two) => 'One = $one, two = $two');

  final mergerresult = Rx.merge([stream1, stream2]);

  final result = stream1.concatWith([stream2]);
  //final combined = Rx.concat([stream1, stream2]);
  // stream1, stream2, (one, two) => 'One = $one, two = $two');

  await for (final value in mergerresult) {
    value.log();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    testit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(8.0), child: Text("Home Page")),
      ),
    );
  }
}
