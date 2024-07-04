import 'package:flutter/cupertino.dart';

@immutable
sealed class DateOfBirthState {}

final class DateOfBirthInitial extends DateOfBirthState {}

class DateOfBirthSelectedState extends DateOfBirthState {
  final String dateOfBirth;

  DateOfBirthSelectedState(this.dateOfBirth);
}
