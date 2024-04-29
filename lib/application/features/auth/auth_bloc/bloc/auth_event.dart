part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}



// login event 

class CheckLoginStatusEvent extends AuthEvent{}

class LoginEvent extends AuthEvent{
  final  String email;
  final String password;

  LoginEvent({required this.email,required this.password}); 
}

// signup event

class SignupEvent extends AuthEvent{
  final UserModel user; 

  SignupEvent ({required this.user}); 
}
