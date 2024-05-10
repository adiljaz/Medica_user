part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}
// ignore: must_be_immutable
class Authenticated extends AuthState{
  User? user; 
  Authenticated(this.user); 
}

class  UnAuthenticated extends AuthState{}

class AuthenticatedError extends AuthState{
  final  String message; 
  AuthenticatedError(this.message); 
  
}

class UseralreadyExisting  extends AuthState{}

class UsrarisNotExisting extends AuthState{}








