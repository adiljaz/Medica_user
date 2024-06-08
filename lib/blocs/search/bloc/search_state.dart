// search_state.dart

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<DocumentSnapshot> searchResults;

  SearchLoaded(this.searchResults);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}
