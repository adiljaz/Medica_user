part of 'forgot_password_bloc.dart';

@immutable
sealed class ForgotPasswordState {}

final class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotpasswordDone extends ForgotPasswordState{}
class ForgotpasswordError extends ForgotPasswordState{}
class ForgotpasswordLoading extends ForgotPasswordState{}

