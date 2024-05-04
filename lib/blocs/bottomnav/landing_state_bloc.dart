// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'landing_state_event.dart';
part 'landing_state_state.dart';

class LandingStateBloc extends Bloc<LandingStateEvent, LandingStateState> {
  LandingStateBloc() : super(LandingStateInitial(tabindex: 0)) {
    on<LandingStateEvent>((event, emit) {
      if (event is TabChangeEvent) {
        emit(LandingStateInitial(tabindex: event.tabindex));
      }
    });
  }
}



