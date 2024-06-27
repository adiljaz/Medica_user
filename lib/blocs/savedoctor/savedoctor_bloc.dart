import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'savedoctor_event.dart';
import 'savedoctor_state.dart';

class SaveDoctorBloc extends Bloc<SaveDoctorEvent, SaveDoctorState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SaveDoctorBloc() : super(SaveDoctorInitial()) {
    on<SaveDoctorBooking>(_onSaveBooking);
  }

  Future<void> _onSaveBooking(SaveDoctorBooking event, Emitter<SaveDoctorState> emit) async {
    try {
      final String formattedDate = DateFormat('yyyy-MM-dd').format(event.selectedDay);
      final String formattedTime = DateFormat('h:mm a').format(event.selectedTimeSlot);

      final CollectionReference userCollection = _firestore.collection('userbooking');

      await userCollection.add({
        'department': event.doctordepartment,
        'hospitalName': event.hospital,
        'selectedDay': formattedDate,
        'selectedTimeSlot': formattedTime,
        'name': event.name,
        'image': event.image,
        'disease': event.disease,
        'problem': event.problem,
        'uid': event.uid,
      });

      emit(CalendarSuccess());
    } catch (e) {
      print(e);
      emit(CalendarError(message: 'Failed to save booking'));
    }
  }

  Future<void> onCancelAppointment(String appointmentId, String doctorId) async {
    try {
      final appointmentSnapshot = await FirebaseFirestore.instance.collection('userbooking').doc(appointmentId).get();

      if (appointmentSnapshot.exists) {
        final selectedDay = appointmentSnapshot['selectedDay'];
        final selectedTimeSlot = appointmentSnapshot['selectedTimeSlot'];

        // Delete the appointment from 'userbooking' collection
        await appointmentSnapshot.reference.delete();

        // Add canceled appointment to 'cancelledappointments' collection
        final cancelledCollection = _firestore.collection('userbooking').doc(_auth.currentUser!.uid).collection('canceledappoinement');
        await cancelledCollection.add({
          'department': appointmentSnapshot['department'],
          'hospitalName': appointmentSnapshot['hospitalName'],
          'selectedDay': selectedDay,
          'selectedTimeSlot': selectedTimeSlot,
          'name': appointmentSnapshot['name'],
          'image': appointmentSnapshot['image'],
          'disease': appointmentSnapshot['disease'],
          'problem': appointmentSnapshot['problem'],
          'uid': appointmentSnapshot['uid'],
          'doctorId': doctorId,
        });
      }
    } catch (e) {
      print('Error cancelling appointment: $e');
      // Handle error here
    }
  }
}
