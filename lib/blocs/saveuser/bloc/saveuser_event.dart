import 'package:flutter/material.dart';

@immutable
abstract class SaveUserEvent {}

class SaveUserBooking extends SaveUserEvent {
  final DateTime selectedDay;
  final DateTime selectedTimeSlot;
  final String uid;
  final String fromTime;
  final String toTime;
  final String name;
  final String image;
  final String gender;
  final String age;
  final String disease;
  final String problem;

  SaveUserBooking({
    required this.selectedDay,
    required this.selectedTimeSlot,
    required this.uid,
    required this.fromTime,
    required this.toTime,
    required this.image,
    required this.name,
    required this.gender,
    required this.age,
    required this.disease,
    required this.problem,
  });
}

class CancelUserBooking extends SaveUserEvent {
  final String appointmentId;
  final String doctorId;

  CancelUserBooking({
    required this.appointmentId,
    required this.doctorId,
  });
}
