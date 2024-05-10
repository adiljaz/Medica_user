part of 'delete_bloc.dart';

@immutable
sealed class DeleteEvent {}

 class DeleteClick extends DeleteEvent{
  final String id;

  DeleteClick({required this.id});
 }
