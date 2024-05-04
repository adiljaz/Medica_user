part of 'nextpage_bloc.dart';

@immutable
sealed class NextpageState {}

final class NextpageInitial extends NextpageState {}

class OnclickDone extends NextpageState {
  final String done;
  OnclickDone({required this.done});
}

class Skip extends NextpageState {}

class OnclickNotDone extends NextpageState {
  final String error;
  OnclickNotDone(this.error);
}
