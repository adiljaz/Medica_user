import 'package:flutter/material.dart';

@immutable
abstract class SaveUserState {}

class SaveUserInitial extends SaveUserState {}

class CalendarUpdated extends SaveUserState {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final List<DateTime> timeSlots;
  final List<DateTime> bookedSlots;
  final DateTime? selectedTimeSlot;

  CalendarUpdated({
    required this.focusedDay,
    required this.selectedDay,
    required this.timeSlots,
    required this.bookedSlots,
    this.selectedTimeSlot,
  });
}

class CalendarSuccess extends SaveUserState {
  
}

class CalendarError extends SaveUserState {
  final String message;

  CalendarError({
    required this.message,
  });
}