abstract class CalendarEvent {}

class GenerateTimeSlots extends CalendarEvent {
  final String fromTime;
  final String toTime;
  final String uid;

  GenerateTimeSlots({required this.fromTime, required this.toTime, required this.uid});
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

class SaveBooking extends CalendarEvent {
  final DateTime selectedDay;
  final DateTime selectedTimeSlot;
  final String uid;

  SaveBooking({required this.selectedDay, required this.selectedTimeSlot, required this.uid});
}

