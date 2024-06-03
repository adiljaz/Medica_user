import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {

  final FirebaseAuth _auth =FirebaseAuth.instance;


  final CollectionReference userCollection = FirebaseFirestore.instance
      .collection('doctor')
      .doc()
      .collection('bookedlotes')
      .doc('gave selected date as id')
      .collection('dialy bookings');

  CalendarBloc() : super(CalendarInitial()) {
    on<GenerateTimeSlots>(_onGenerateTimeSlots);
    on<CalendarDaySelected>(_onCalendarDaySelected);
    on<TimeSlotSelected>(_onTimeSlotSelected); // Add this line
  }

  void _onGenerateTimeSlots(
      GenerateTimeSlots event, Emitter<CalendarState> emit) {
    try {
      final List<DateTime> timeSlots =
          _generateTimeSlots(event.fromTime, event.toTime);
      emit(CalendarUpdated(
        focusedDay: DateTime.now(),
        timeSlots: timeSlots,
      ));
    } catch (e) {
      emit(CalendarError(message: e.toString()));
    }
  }

  void _onCalendarDaySelected(
      CalendarDaySelected event, Emitter<CalendarState> emit) {
    if (state is CalendarUpdated) {
      final currentState = state as CalendarUpdated;
      emit(CalendarUpdated(
        focusedDay: event.focusedDay,
        selectedDay: event.selectedDay,
        timeSlots: currentState.timeSlots,
      ));
      
    }
  }

  void _onTimeSlotSelected(
      TimeSlotSelected event, Emitter<CalendarState> emit) {
    if (state is CalendarUpdated) {
      final currentState = state as CalendarUpdated;
      emit(CalendarUpdated(
        focusedDay: currentState.focusedDay,
        selectedDay: currentState.selectedDay,
        timeSlots: currentState.timeSlots,
        selectedTimeSlot: event.selectedTimeSlot,
      ));
    }
  }

  List<DateTime> _generateTimeSlots(String fromTime, String toTime) {
    final List<DateTime> slots = [];
    final DateFormat formatter =
        DateFormat('h:mm a'); // Adjusted to 'h:mm a' format

    DateTime start = formatter.parse(fromTime);
    DateTime end = formatter.parse(toTime);

    // Normalize to the same date for comparison purposes
    DateTime startDateTime = DateTime(1970, 1, 1, start.hour, start.minute);
    DateTime endDateTime = DateTime(1970, 1, 1, end.hour, end.minute);

    // Add debugging statements
    print('Generating time slots from: $fromTime to: $toTime');
    print('Parsed start time: $startDateTime');
    print('Parsed end time: $endDateTime');

    if (startDateTime.isAfter(endDateTime)) {
      print('Start time is after end time. No slots to generate.');
      return slots;
    }

    while (startDateTime.isBefore(endDateTime)) {
      slots.add(startDateTime);
      startDateTime = startDateTime.add(const Duration(minutes: 30));
    }

    // Adding the end time slot
    slots.add(endDateTime);

    print('Generated slots: $slots');
    return slots;
  }
}
