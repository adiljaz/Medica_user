part of 'landing_state_bloc.dart';

@immutable
sealed class LandingStateEvent {}

class TabChangeEvent extends LandingStateEvent {
  final int tabindex;
  TabChangeEvent({required this.tabindex});
}

 









