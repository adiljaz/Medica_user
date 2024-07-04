// gender_event.dart
abstract class GenderEvent {}

class GenderSelected extends GenderEvent {
  final String selectedGender;

  GenderSelected(this.selectedGender);
}
