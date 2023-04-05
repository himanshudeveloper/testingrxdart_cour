import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:testingrxdart_course/models/animal.dart';
import 'package:testingrxdart_course/models/person.dart';
import 'package:testingrxdart_course/models/thing.dart';

typedef SearchTerm = String;

class Api {
  List<Animal>? _animals;
  List<Person>? _persons;
  Api();

  Future<List<Thing>> search(SearchTerm searchTerm) async {
    final term = searchTerm.trim().toLowerCase();
    // search in the cache
    final cacheResults = _extractThingUsigSearchTerm(term);
    if (cacheResults != null) {
      return cacheResults;
    }
    // we don't have the value cached
    // start by calling person api
    final persons = await _getJson('http://127.0.0.1:5500/apis/persons.json')
        .then((json) => json.map((value) => Person.fromJson(value)));

    _persons = persons.toList();

    final animals = await _getJson('http://127.0.0.1:5500/apis/animals.json')
        .then((json) => json.map((value) => Animal.fromJson(value)));

    _animals = animals.toList();

    return _extractThingUsigSearchTerm(searchTerm) ?? [];
  }

  List<Thing>? _extractThingUsigSearchTerm(SearchTerm term) {
    final cachedAnimals = _animals;
    final cachedPersons = _persons;
    if (cachedAnimals != null && cachedPersons != null) {
      List<Thing> result = [];
      // go through animal
      for (final animal in cachedAnimals) {
        if (animal.name.trimmedContains(term) ||
            animal.type.name.trimmedContains(term)) {
          result.add(animal);
        }
      }
      // go through person
      for (final person in cachedPersons) {
        if (person.name.trimmedContains(term) ||
            person.age.toString().trimmedContains(term)) {
          result.add(person);
        }
      }
      return result;
    } else {
      return null;
    }
  }

  Future<List<dynamic>> _getJson(String url) => HttpClient()
      .getUrl(Uri.parse(url))
      .then((value) => value.close())
      .then((response) => response.transform(utf8.decoder).join())
      .then((jsonString) => json.decode(jsonString) as List<dynamic>);
}

extension TrimmedcaseInsensitiveContain on String {
  bool trimmedContains(String other) =>
      trim().toLowerCase().contains(other.trim().toLowerCase());
}
