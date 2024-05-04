part of 'landing_state_bloc.dart';

@immutable
sealed class LandingStateState {
  final int tabindex;
   LandingStateState({required this.tabindex});
}

final class LandingStateInitial extends LandingStateState {
   LandingStateInitial({required super.tabindex});
  
}





