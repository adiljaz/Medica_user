import 'package:flutter/material.dart';

@immutable
abstract class CalendarEvent {}

class GenerateTimeSlots extends CalendarEvent {
  final String fromTime;
  final String toTime;
  final String uid;
  final DateTime selectedDay;

  GenerateTimeSlots({
    required this.fromTime,
    required this.toTime,
    required this.uid,
    required this.selectedDay,
  });
}

class CalendarDaySelected extends CalendarEvent {
  final DateTime selectedDay;
  final DateTime focusedDay;

  CalendarDaySelected({
    required this.selectedDay,
    required this.focusedDay,
  });
}

class TimeSlotSelected extends CalendarEvent {
  final DateTime selectedTimeSlot;

  TimeSlotSelected({
    required this.selectedTimeSlot,
  });
}

class SaveBooking extends CalendarEvent {
  final DateTime selectedDay;
  final DateTime selectedTimeSlot;
  final String uid;
  final String fromTime;
  final String toTime;
  

  SaveBooking({
    required this.selectedDay,
    required this.selectedTimeSlot,
    required this.uid,
    required this.fromTime,
    required this.toTime,
  });
}