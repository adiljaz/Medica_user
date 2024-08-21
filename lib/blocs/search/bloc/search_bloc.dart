import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/blocs/search/bloc/search_event.dart';
import 'package:fire_login/blocs/search/bloc/search_state.dart';



class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitialState());

  @override
  // ignore: override_on_non_overriding_member
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchDoctorsEvent) {
      yield SearchLoadingState();
      try {
        List<DocumentSnapshot> doctors = await _searchDoctors(event.query);
        yield SearchSuccessState(doctors);
      } catch (e) {
        yield SearchErrorState('Error searching doctors');
      }
    }
  }

  Future<List<DocumentSnapshot>> _searchDoctors(String query) async {
    if (query.isNotEmpty) {
      var doctors = await FirebaseFirestore.instance
          .collection('doctor')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      return doctors.docs;
    } else {
      return [];
    }
  }
}
