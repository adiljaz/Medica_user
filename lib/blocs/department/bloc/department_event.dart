part of 'department_bloc.dart';

@immutable
sealed class GenderEvent {}

class GenderSelected extends GenderEvent{
  final String selecteGender;

  GenderSelected({required this.selecteGender});
}
