part of 'nextpage_bloc.dart';

@immutable
sealed class NextpageEvent {}

class CheckNextClickEvent extends NextpageEvent {
  final bool pageTwo;

  CheckNextClickEvent({required this.pageTwo});
}

class OnClickEvent extends NextpageEvent {}
