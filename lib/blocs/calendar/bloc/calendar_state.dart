abstract class CalendarState {}

class CalendarInitial extends CalendarState {}

class CalendarUpdated extends CalendarState {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final List<DateTime> timeSlots;
  final DateTime? selectedTimeSlot;

  CalendarUpdated({
    required this.focusedDay,
    this.selectedDay,
    required this.timeSlots,
    this.selectedTimeSlot,
  });
}

class CalendarError extends CalendarState {
  final String message;

  CalendarError({required this.message});
}
