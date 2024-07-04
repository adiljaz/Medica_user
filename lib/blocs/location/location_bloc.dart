import 'package:bloc/bloc.dart';
import 'package:fire_login/blocs/location/location_event.dart';
import 'package:fire_login/blocs/location/location_state.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';




class LocationBlocBloc extends Bloc<LocationBlocEvent, LocationBlocState> {
  LocationBlocBloc() : super(LocationBlocInitial()) {
    on<LocationBlocEvent>(_handleEvent);
  }

  void _handleEvent(
      LocationBlocEvent event, Emitter<LocationBlocState> emit) async {
    if (event is RequestCurrentPosition) {
      emit(LocationLoading());
      try {
        var currentPosition = await _getPosition();
        emit(LocationLoaded(
            await _getAddress(currentPosition.latitude, currentPosition.longitude)));
      } catch (e) {
        emit(LocationError(e.toString()));
      }
    } else if (event is FetchAddress) {
      emit(LocationLoading());
      try {
        var address = await _getAddress(event.latitude, event.longitude);
        emit(LocationLoaded(address));
      } catch (e) {
        emit(LocationError(e.toString()));
      }
    }
  }

  Future<Position> _getPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      } else if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> _getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        // Constructing the address string
        String address = ' ${place.subLocality}, ${place.locality},${place.administrativeArea},${place.country}';
        return address;
      } else {
        return 'No address found.';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
