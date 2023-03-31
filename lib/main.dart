import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

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

class MyHomePage extends HookWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //create a behavior subject every time widget is created
    final subject = useMemoized(() => BehaviorSubject<String>(), [key]);
    //destroy a behavior subject every time widget is created
    useEffect(() => subject.close, [subject]);

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
            stream: subject.stream
                .distinct()
                .debounceTime(const Duration(seconds: 1)),
            initialData: 'Please start typing',
            builder: (context, snapshot) {
              return Text(snapshot.requireData);
            }),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: subject.sink.add,
          ),
        ),
      ),
    );
  }
}
