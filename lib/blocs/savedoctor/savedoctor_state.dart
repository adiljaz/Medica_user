import 'package:flutter/material.dart';

@immutable
abstract class SaveDoctorState {}

class SaveDoctorInitial extends SaveDoctorState {}

class CalendarSuccess extends SaveDoctorState { 
}
class CalendarError extends SaveDoctorState {
  final String message;

  CalendarError({
    required this.message,
  });
}