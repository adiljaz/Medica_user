part of 'favorite_bloc.dart';

@immutable
abstract class FavoriteEvent {}

class LoadFavoritesEvent extends FavoriteEvent {}

class ToggleFavoriteEvent extends FavoriteEvent {
  final String doctorId;
  final bool isFavorite;

  ToggleFavoriteEvent(this.doctorId, this.isFavorite);
}
