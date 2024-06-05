import 'package:flutter/material.dart';

@immutable
abstract class CalendarState {}

class CalendarInitial extends CalendarState {}

class CalendarUpdated extends CalendarState {
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

class CalendarSuccess extends CalendarState {}

class CalendarError extends CalendarState {
  final String message;

  CalendarError({
    required this.message,
  });
}
