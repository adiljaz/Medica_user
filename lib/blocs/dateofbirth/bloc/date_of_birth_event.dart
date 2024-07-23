abstract class DateOfBirthEvent {}

class DateOfBirthSelected extends DateOfBirthEvent {
  final DateTime selectedDate;

  DateOfBirthSelected(this.selectedDate);
}

class DateOfBirthCleared extends DateOfBirthEvent {}