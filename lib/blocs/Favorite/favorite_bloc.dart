import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FavoriteBloc() : super(FavoriteInitial()) {
    on<LoadFavoritesEvent>(_loadFavorites);
    on<ToggleFavoriteEvent>(_toggleFavorite);
  }

  void _loadFavorites(LoadFavoritesEvent event, Emitter<FavoriteState> emit) async {
    try {
      emit(FavoriteLoading());
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        emit(FavoriteError("User not logged in"));
        return;
      }
      final favoriteDocs = await _firestore.collection('users').doc(userId).collection('favorites').get();
      final favorites = favoriteDocs.docs.map((doc) => doc.id).toList();

      emit(FavoriteLoaded(favorites));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  void _toggleFavorite(ToggleFavoriteEvent event, Emitter<FavoriteState> emit) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        emit(FavoriteError("User not logged in"));
        return;
      }

      final docRef = _firestore.collection('users').doc(userId).collection('favorites').doc(event.doctorId);

      if (event.isFavorite) {
        await docRef.delete();
      } else {
        await docRef.set({});
      }

      final favoriteDocs = await _firestore.collection('users').doc(userId).collection('favorites').get();
      final favorites = favoriteDocs.docs.map((doc) => doc.id).toList();

      emit(FavoriteLoaded(favorites));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }
}
