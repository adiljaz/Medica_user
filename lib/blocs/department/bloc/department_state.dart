part of 'department_bloc.dart';

@immutable
sealed class GenderState {}

final class GenderInitial extends GenderState {}

class GenderSelectedState extends GenderState {
  final String selectedGender;

  GenderSelectedState({required this.selectedGender});
}
