import 'package:flutter/foundation.dart' show immutable;
import 'package:testingrxdart_course/models/thing.dart';

@immutable
class Person extends Thing {
  final int age;

  const Person({required String name, required this.age}) : super(name: name);

  @override
  String toString() => 'Person, name: $name, age: $age';

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(name: json["name"] as String, age: json["age"] as int);
  }
}
