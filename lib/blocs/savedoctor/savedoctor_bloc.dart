import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/blocs/savedoctor/savedoctor_event.dart';
import 'package:fire_login/blocs/savedoctor/savedoctor_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SaveDoctorBloc extends Bloc<SaveDoctorEvent, SaveDoctorState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth =FirebaseAuth.instance;

  SaveDoctorBloc() : super(SaveDoctorInitial()) {
    on<SaveDoctorBooking>(_onSaveBooking);
  }

  Future<void> _onSaveBooking(
      SaveDoctorBooking event, Emitter<SaveDoctorState> emit) async {
    try {
      final String formattedDate = 
          DateFormat('yyyy-MM-dd').format(event.selectedDay);
      final String formattedTime =
          DateFormat('h:mm a').format(event.selectedTimeSlot);

      final CollectionReference userCollection = _firestore
          .collection('userbooking');
         

      await userCollection.add({
        'department': event.doctordepartment,
        'hospitalName': event.hospital,
        'selectedDay': formattedDate,
        'selectedTimeSlot': formattedTime,
        'name': event.name,
        'image': event.image,
        'disease': event.disease,
        'problem': event.problem,
      });

      emit(CalendarSuccess());
    } catch (e) {
      print(e);
      emit(CalendarError(message: 'Failed to save booking'));
    }
  }
}
