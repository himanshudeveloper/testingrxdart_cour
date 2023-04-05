import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:testingrxdart_course/bloc/search_result.dart';

import 'api.dart';

@immutable
class SearchBloc {
  final Sink<String> search;
  final Stream<SearchResult?> results;


  void dispose (){
    search.close();
    
  }

  factory SearchBloc({required Api api}) {
    final textChanges = BehaviorSubject<String>();
    final result = textChanges
        .distinct()
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap<SearchResult?>((String searchterm) {
      if (searchterm.isEmpty) {
        //search term is empty
        return Stream<SearchResult?>.value(null);
      } else {
        return Rx.fromCallable(() => api.search(searchterm))
            .delay(const Duration(seconds: 1))
            .map((results) => results.isEmpty
                ? const SearchResultNotResult()
                : SearchResultWithResults(results))
            .startWith(const SearchResultLoading())
            .onErrorReturnWith((error, _) => SearchResultHasError(error));
      }
    });

    return SearchBloc._(search: textChanges.sink, results: result);
  }

  const SearchBloc._({required this.search, required this.results});
}
