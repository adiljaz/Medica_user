import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';
import 'package:intl/intl.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarInitial()) {
    on<GenerateTimeSlots>(_onGenerateTimeSlots);
    on<CalendarDaySelected>(_onCalendarDaySelected);
    on<TimeSlotSelected>(_onTimeSlotSelected);
    on<SaveBooking>(_onSaveBooking); 
  }

  void _onGenerateTimeSlots(GenerateTimeSlots event, Emitter<CalendarState> emit) async {
    try {
      // Fetch booked slots for the selected day
      final bookedSlots = await _fetchBookedSlots(event.selectedDay, event.uid);
      final List<DateTime> timeSlots = _generateTimeSlots(event.fromTime, event.toTime, bookedSlots);

      emit(CalendarUpdated(
        focusedDay: event.selectedDay,
        selectedDay: event.selectedDay,
        timeSlots: timeSlots,
        bookedSlots: bookedSlots,
      ));
    } catch (e) {
      emit(CalendarError(message: e.toString()));
    }
  }

  void _onCalendarDaySelected(CalendarDaySelected event, Emitter<CalendarState> emit) {
    if (state is CalendarUpdated) {
      final currentState = state as CalendarUpdated;
      emit(CalendarUpdated(
        focusedDay: event.focusedDay,
        selectedDay: event.selectedDay,
        timeSlots: currentState.timeSlots,
        bookedSlots: currentState.bookedSlots,
      ));
    }
  }

  void _onTimeSlotSelected(TimeSlotSelected event, Emitter<CalendarState> emit) {
    if (state is CalendarUpdated) {
      final currentState = state as CalendarUpdated;
      emit(CalendarUpdated(
        focusedDay: currentState.focusedDay,
        selectedDay: currentState.selectedDay,
        timeSlots: currentState.timeSlots,
        bookedSlots: currentState.bookedSlots,
        selectedTimeSlot: event.selectedTimeSlot,
      ));
    }
  }

  Future<void> _onSaveBooking(SaveBooking event, Emitter<CalendarState> emit) async {
    try {
      final String formattedDate = DateFormat('yyyy-MM-dd').format(event.selectedDay);
      final String formattedTime = DateFormat('h:mm a').format(event.selectedTimeSlot);

      final CollectionReference userCollection = FirebaseFirestore.instance
          .collection('doctor')
          .doc(event.uid)
          .collection('bookedSlots')
          .doc(formattedDate)
          .collection('dailyBookings');

      await userCollection.add({
        'selectedDay': formattedDate,
        'selectedTimeSlot': formattedTime,
      });

      // Re-fetch booked slots and update state
      final bookedSlots = await _fetchBookedSlots(event.selectedDay, event.uid);
      final List<DateTime> timeSlots = _generateTimeSlots(formattedTime, formattedTime, bookedSlots);

      emit(CalendarUpdated(
        focusedDay: event.selectedDay,
        selectedDay: event.selectedDay,
        timeSlots: timeSlots,
        bookedSlots: bookedSlots,
        selectedTimeSlot: event.selectedTimeSlot,
      ));
      emit(CalendarSuccess());
    } catch (e) {
      emit(CalendarError(message: e.toString()));
    }
  }

  Future<List<DateTime>> _fetchBookedSlots(DateTime selectedDay, String uid) async {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);

    final CollectionReference userCollection = FirebaseFirestore.instance
        .collection('doctor')
        .doc(uid)
        .collection('bookedSlots')
        .doc(formattedDate)
        .collection('dailyBookings');

    final QuerySnapshot snapshot = await userCollection.get();
    final List<DateTime> bookedSlots = [];

    snapshot.docs.forEach((doc) {
      final String time = doc['selectedTimeSlot'];
      final DateTime dateTime = DateFormat('h:mm a').parse(time);
      bookedSlots.add(dateTime);
    });

    return bookedSlots;
  }

  List<DateTime> _generateTimeSlots(String fromTime, String toTime, List<DateTime> bookedSlots) {
    final List<DateTime> slots = [];
    final DateFormat formatter = DateFormat('h:mm a');

    DateTime start = formatter.parse(fromTime);
    DateTime end = formatter.parse(toTime);

    DateTime startDateTime = DateTime(1970, 1, 1, start.hour, start.minute);
    DateTime endDateTime = DateTime(1970, 1, 1, end.hour, end.minute);

    while (startDateTime.isBefore(endDateTime)) {
      if (!bookedSlots.contains(startDateTime)) {
        slots.add(startDateTime);
      }
      startDateTime = startDateTime.add(const Duration(minutes: 30));
    }

    if (!bookedSlots.contains(endDateTime)) {
      slots.add(endDateTime);
    }

    return slots;
  }
}
