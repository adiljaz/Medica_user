// location_bloc_event.dart
abstract class LocationBlocEvent {}

class RequestCurrentPosition extends LocationBlocEvent {}

class FetchAddress extends LocationBlocEvent {
  final double latitude;
  final double longitude;

  FetchAddress(this.latitude, this.longitude);
}
