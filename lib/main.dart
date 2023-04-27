import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as devtools show log;
import 'package:flutter/foundation.dart' show immutable;

// extension Log on Object {
//   void log() => devtools.log(toString());
// }

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

@immutable
class Bloc {
  final Sink<String?> setFirstName; // write only
  final Sink<String?> setLastName; // write only
  final Stream<String?> fullName; // read only

  const Bloc._({
    required this.setFirstName,
    required this.setLastName,
    required this.fullName,
  });

  void dispose() {
    setFirstName.close();
    setLastName.close();
  }

  factory Bloc() {
    final firstNameSubject = BehaviorSubject<String?>();
    final lastNameSubject = BehaviorSubject<String?>();
    final Stream<String> fullName = Rx.combineLatest2(
        firstNameSubject.startWith(null), lastNameSubject.startWith(null),
        (String? firstName, String? lastName) {
      if (firstName != null &&
          firstName.isNotEmpty &&
          lastName != null &&
          lastName.isNotEmpty) {
        return "$firstName $lastName";
      } else {
        return 'Both first and last name must be provided';
      }
    });

    return Bloc._(
        setFirstName: firstNameSubject.sink,
        setLastName: lastNameSubject.sink,
        fullName: fullName);
  }
}

typedef AsyncSnapshotBuilderCallback<T> = Widget Function(
    BuildContext context, T? value);

class AsyncSnapshotBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final AsyncSnapshotBuilderCallback<T>? onNone;
  final AsyncSnapshotBuilderCallback<T>? onWaiting;
  final AsyncSnapshotBuilderCallback<T>? onActive;
  final AsyncSnapshotBuilderCallback<T>? onDone;
  const AsyncSnapshotBuilder({
    super.key,
    required this.stream,
    this.onNone,
    this.onWaiting,
    this.onActive,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(builder: 
    
    
    
    )
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
