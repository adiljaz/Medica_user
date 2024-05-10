part of 'add_user_bloc.dart';

@immutable
sealed class AddUserEvent {}

class AddUserClick extends AddUserEvent {
  final String name;
  final int age;
  final int dob;
  final String imageUrl;
  final String gender;
  final String location;
 final int mobile;

  AddUserClick(
      {required this.name,
      required this.age,
      required this.dob,
      required this.imageUrl,
      required this.gender,
      required this.location,
      
      required this.mobile,
      
      });
}
