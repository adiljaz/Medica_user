import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'saveuser_event.dart';
import 'saveuser_state.dart';

class SaveUserBloc extends Bloc<SaveUserEvent, SaveUserState> {
  SaveUserBloc() : super(SaveUserInitial()) {
    on<SaveUserBooking>(_onSaveBooking);
    on<CancelUserBooking>(_onCancelBooking);
  }

  void _onSaveBooking(SaveUserBooking event, Emitter<SaveUserState> emit) async {
    try {
      final String formattedDate = DateFormat('yyyy-MM-dd').format(event.selectedDay);
      final String formattedTime = DateFormat('h:mm a').format(event.selectedTimeSlot);

      final CollectionReference userCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(event.uid)
          .collection('userbookings');

      await userCollection.add({
        'selectedDay': formattedDate,
        'selectedTimeSlot': formattedTime,
        'name': event.name,
        'gender': event.gender,
        'image': event.image,
        'age': event.age,
        'disease': event.disease,
        'problem': event.problem,
        'uid':event.uid, 
      });

      final bookedSlots = await _fetchBookedSlots(event.selectedDay, event.uid);
      final List<DateTime> timeSlots = _generateTimeSlots(event.fromTime, event.toTime);

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

  void _onCancelBooking(CancelUserBooking event, Emitter<SaveUserState> emit) async {
    try {
      final appointmentSnapshot = await FirebaseFirestore.instance
          .collection('userbooking') 
          .doc(event.appointmentId)
          .get();

      if (appointmentSnapshot.exists) {
        final selectedDay = appointmentSnapshot['selectedDay'];
        final selectedTimeSlot = appointmentSnapshot['selectedTimeSlot'];

        // Delete the appointment from 'userbooking' collection
        await appointmentSnapshot.reference.delete();

        // Now free up the time slot in the doctor's 'dailyBookings' collection
        final doctorRef = FirebaseFirestore.instance.collection('doctor').doc(event.doctorId);
        final dailyBookingRef = doctorRef.collection('dailyBookings');
        final bookedSlot = await dailyBookingRef
            .where('selectedDay', isEqualTo: selectedDay)
            .where('selectedTimeSlot', isEqualTo: selectedTimeSlot)
            .get();

        if (bookedSlot.docs.isNotEmpty) {
          await bookedSlot.docs.first.reference.delete();
        }
      }
    } catch (e) {
      emit(CalendarError(message: 'Error cancelling appointment: $e'));
    }
  }

  Future<List<DateTime>> _fetchBookedSlots(DateTime selectedDay, String uid) async {
    final CollectionReference userCollection = FirebaseFirestore.instance
        .collection('doctor')
        .doc(uid)
        .collection('dailyBookings');

    final QuerySnapshot snapshot = await userCollection
        .where('selectedDay', isEqualTo: DateFormat('yyyy-MM-dd').format(selectedDay))
        .get();
    final List<DateTime> bookedSlots = [];

    snapshot.docs.forEach((doc) {
      final String time = doc['selectedTimeSlot'];
      final DateTime dateTime = DateFormat('h:mm a').parse(time);
      bookedSlots.add(dateTime);
    });

    return bookedSlots;
  }

  List<DateTime> _generateTimeSlots(String fromTime, String toTime) {
    final List<DateTime> slots = [];
    final DateFormat formatter = DateFormat('h:mm a');

    DateTime start = formatter.parse(fromTime);
    DateTime end = formatter.parse(toTime);

    DateTime startDateTime = DateTime(1970, 1, 1, start.hour, start.minute);
    DateTime endDateTime = DateTime(1970, 1, 1, end.hour, end.minute);

    while (startDateTime.isBefore(endDateTime)) {
      slots.add(startDateTime);
      startDateTime = startDateTime.add(const Duration(minutes: 30));
    }

    slots.add(endDateTime);

    return slots;
  }
}