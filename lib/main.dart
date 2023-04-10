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

enum TypeOfThing { animal, person }

@immutable
class Thing {
  final TypeOfThing type;
  final String name;

  const Thing({required this.name, required this.type});
}

@immutable
class Bloc {
  final Sink<TypeOfThing?> setTypeOfThing; // write only
  final Stream<TypeOfThing?> currentTypeofThing; // read only
  final Stream<Iterable<Thing>> things;

  const Bloc._(
      {required this.setTypeOfThing,
      required this.currentTypeofThing,
      required this.things});

  // write only

  void dispose() {
    setTypeOfThing.close();
  }

  factory Bloc({
    required Iterable<Thing> things,
  }) {
    final typeOfThingSubject = BehaviorSubject<TypeOfThing?>();
    final filteresThings = typeOfThingSubject
        .debounceTime(const Duration(milliseconds: 300))
        .map<Iterable<Thing>>((typeofThing) {
      if (typeofThing != null) {
        return things.where((thing) => thing.type == typeofThing);
      } else {
        return things;
      }
    }).startWith(things);

    return Bloc._(
        setTypeOfThing: typeOfThingSubject.sink,
        currentTypeofThing: typeOfThingSubject.stream,
        things: filteresThings);
  }
}

const things = [
  Thing(name: 'foo', type: TypeOfThing.person),
  Thing(name: 'Bar', type: TypeOfThing.person),
  Thing(name: 'Baz', type: TypeOfThing.person),
  Thing(name: 'Bunz', type: TypeOfThing.animal),
  Thing(name: 'Fluffers', type: TypeOfThing.animal),
  Thing(name: 'Woofz', type: TypeOfThing.animal),
];

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final Bloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = Bloc(things: things);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter Chip with rx dart"),
      ),
      body: Column(
        children: [
          StreamBuilder<TypeOfThing?>(
              stream: bloc.currentTypeofThing,
              builder: (context, snapshot) {
                final selectedtypeofthing = snapshot.data;
                return Wrap(
                    children: TypeOfThing.values.map((typeOfThing) {
                  return FilterChip(
                    label: Text(typeOfThing.name),
                    onSelected: (selected) {
                      final type = selected ? typeOfThing : null;
                      bloc.setTypeOfThing.add(type);
                    },
                    selected: selectedtypeofthing == typeOfThing,
                    selectedColor: Colors.blueAccent,
                  );
                }).toList());
              }),
          Expanded(
              child: StreamBuilder(
            builder: (context, snapshot) {
              final things = snapshot.data ?? [];
              return ListView.builder(
                itemBuilder: (context, index) {
                  final thing = things.elementAt(index);
                  return ListTile(
                    title: Text(thing.name),
                    subtitle: Text(thing.type.name),
                  );
                },
                itemCount: things.length,
              );
            },
            stream: bloc.things,
          ))
        ],
      ),
    );
  }
}
