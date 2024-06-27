import 'package:flutter/material.dart';

@immutable
abstract class SaveDoctorEvent {}

class SaveDoctorBooking extends SaveDoctorEvent {
  final DateTime selectedDay;
  final DateTime selectedTimeSlot;
  final String uid;
  final String fromTime;
  final String toTime;
  final String name;
  final String image;
  final String disease;
  final String problem;
  final String doctorname;
  final String doctordepartment;
  final String hospital;

  SaveDoctorBooking({
    required this.selectedDay,
    required this.selectedTimeSlot,
    required this.uid,
    required this.fromTime,
    required this.toTime,
    required this.name,
    required this.image,
    required this.disease,
    required this.problem,
    required this.doctorname,
    required this.doctordepartment,
    required this.hospital,
  });
}