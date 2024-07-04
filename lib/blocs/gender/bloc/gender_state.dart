// gender_state.dart
abstract class GenderState {}

class GenderInitial extends GenderState {}

class GenderSelectedState extends GenderState {
  final String selectedGender;

  GenderSelectedState(this.selectedGender);
}
