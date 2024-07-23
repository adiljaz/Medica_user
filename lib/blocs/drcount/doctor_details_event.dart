abstract class PatientCountEvent {}

class LoadPatientCount extends PatientCountEvent {
  final String doctorUid;
  LoadPatientCount(this.doctorUid);
}

class IncrementPatientCount extends PatientCountEvent {
  final String doctorUid;
  IncrementPatientCount(this.doctorUid);
}

class DecrementPatientCount extends PatientCountEvent {
  final String doctorUid;
  DecrementPatientCount(this.doctorUid);
}