abstract class CalendarEvent {}

class GenerateTimeSlots extends CalendarEvent {
  final String fromTime;
  final String toTime;

  GenerateTimeSlots({required this.fromTime, required this.toTime});
}

class CalendarDaySelected extends CalendarEvent {
  final DateTime selectedDay;
  final DateTime focusedDay;

  CalendarDaySelected({required this.selectedDay, required this.focusedDay});
}

class TimeSlotSelected extends CalendarEvent {
  final DateTime selectedTimeSlot;

  TimeSlotSelected({required this.selectedTimeSlot});
}
