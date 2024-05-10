part of 'add_user_bloc.dart';

@immutable
sealed class AddUserState {}

final class AddUserInitial extends AddUserState {}
class AddUserLOadingState extends AddUserState{}
class AddUserSuccesState extends AddUserState{}
class AddUserErrorState extends AddUserState{
  final String errorMessage;
  AddUserErrorState(this.errorMessage); 
}


