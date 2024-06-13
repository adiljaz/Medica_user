import 'package:cloud_firestore/cloud_firestore.dart';

abstract class SearchState {}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchSuccessState extends SearchState {
  final List<DocumentSnapshot> results;

  SearchSuccessState(this.results);
}

class SearchErrorState extends SearchState {
  final String error;

  SearchErrorState(this.error);
}
