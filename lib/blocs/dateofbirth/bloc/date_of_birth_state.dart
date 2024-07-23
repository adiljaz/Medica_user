import 'package:flutter/foundation.dart';

@immutable
abstract class DateOfBirthState {}

class DateOfBirthInitial extends DateOfBirthState {}

class DateOfBirthSelectedState extends DateOfBirthState {
  final String dateOfBirth;

  DateOfBirthSelectedState(this.dateOfBirth);
}