part of 'google_auth_bloc.dart';

@immutable
sealed class GoogleAuthState {}

final class GoogleAuthInitial extends GoogleAuthState {}

final class GoogleAuthPendingn extends GoogleAuthState{}

final class GoogleAuthError extends GoogleAuthState{}

final class GoogleAuthsuccess extends GoogleAuthState{}




