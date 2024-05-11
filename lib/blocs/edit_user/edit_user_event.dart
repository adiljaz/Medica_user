part of 'edit_user_bloc.dart';

@immutable
sealed class EditUserEvent {}

class EditUserClick extends EditUserEvent {
  final String name;
  final int age;
  final String location;
  final int dob;
  final int mobile;
  final String gender;
  final String imaage;
  final String uid;

  final Map<String,Object> data;

  EditUserClick(
      {required this.name,
      required this.age,
      required this.location,
      required this.dob,
      required this.mobile,
      required this.gender,
      required this.imaage,
      required this.uid,
      required this.data
      });
}
