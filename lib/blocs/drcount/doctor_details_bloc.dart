import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'doctor_details_event.dart';
import 'doctor_details_state.dart';

class PatientCountBloc extends Bloc<PatientCountEvent, PatientCountState> {
  PatientCountBloc() : super(PatientCountState(0)) {
    on<LoadPatientCount>(_onLoadPatientCount);
    on<IncrementPatientCount>(_onIncrementPatientCount);
    on<DecrementPatientCount>(_onDecrementPatientCount);
  }

  Future<void> _onLoadPatientCount(LoadPatientCount event, Emitter<PatientCountState> emit) async {
    print('Loading patient count for doctor: ${event.doctorUid}');
    final doctorDoc = await FirebaseFirestore.instance
        .collection('doctor')
        .doc(event.doctorUid)
        .get();
    
    final patientCount = doctorDoc.data()?['patientCount'] ?? 0;
    emit(PatientCountState(patientCount));
  }

  Future<void> _onIncrementPatientCount(IncrementPatientCount event, Emitter<PatientCountState> emit) async {
    print('Incrementing patient count for doctor: ${event.doctorUid}');
    final newCount = state.count + 1;
    try {
      await FirebaseFirestore.instance
          .collection('doctor')
          .doc(event.doctorUid)
          .update({'patientCount': newCount});
      emit(PatientCountState(newCount));
    } catch (e) {
      print('Error incrementing patient count: $e');
    }
  }

  Future<void> _onDecrementPatientCount(DecrementPatientCount event, Emitter<PatientCountState> emit) async {
    print('Decrementing patient count for doctor: ${event.doctorUid}');
    final newCount = state.count > 0 ? state.count - 1 : 0;
    try {
      await FirebaseFirestore.instance
          .collection('doctor')
          .doc(event.doctorUid)
          .update({'patientCount': newCount});
      emit(PatientCountState(newCount));
    } catch (e) {
      print('Error decrementing patient count: $e');
    }
  }
}