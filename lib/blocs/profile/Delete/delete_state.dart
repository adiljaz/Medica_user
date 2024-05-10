part of 'delete_bloc.dart';

@immutable
sealed class DeleteState {}

final class DeleteInitial extends DeleteState {}

final class DeleteDoneState extends DeleteState{}
final class DeleteErrorState extends DeleteState{}
