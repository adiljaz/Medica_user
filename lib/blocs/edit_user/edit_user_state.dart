part of 'edit_user_bloc.dart';

@immutable
sealed class EditUserState {}

final class EditUserInitial extends EditUserState {}

final class EditUserLoading extends EditUserState{}
final class EditUserSucces extends EditUserState{}
final class EditUserErroState extends EditUserState{

  final String error;

  EditUserErroState({required this.error});
}

