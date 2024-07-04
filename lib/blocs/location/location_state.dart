// location_bloc_state.dart
import 'package:flutter/widgets.dart';

@immutable
abstract class LocationBlocState {}

class LocationBlocInitial extends LocationBlocState {}

class LocationLoading extends LocationBlocState {}

class LocationLoaded extends LocationBlocState {
  final String address;

  LocationLoaded(this.address);
}

class LocationError extends LocationBlocState {
  final String message;

  LocationError(this.message);
}
