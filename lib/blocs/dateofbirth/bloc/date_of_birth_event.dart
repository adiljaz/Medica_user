// date_of_birth_event.dart
abstract class DateOfBirthEvent {}

class DateOfBirthSelected extends DateOfBirthEvent {
  final DateTime selectedDate;

  DateOfBirthSelected(this.selectedDate);
}
