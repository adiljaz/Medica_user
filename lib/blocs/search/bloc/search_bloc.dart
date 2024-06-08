// search_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
  }

  void _onSearchQueryChanged(
      SearchQueryChanged event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      if (event.query.isNotEmpty) {
        var doctors = await FirebaseFirestore.instance
            .collection('doctor')
            .where('name', isGreaterThanOrEqualTo: event.query)
            .where('name', isLessThanOrEqualTo: event.query + '\uf8ff')
            .get();
        emit(SearchLoaded(doctors.docs));
      } else {
        emit(SearchLoaded([]));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
