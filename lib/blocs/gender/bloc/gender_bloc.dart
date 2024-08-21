
import 'package:flutter_bloc/flutter_bloc.dart';
import 'gender_event.dart';
import 'gender_state.dart';

class GenderBloc extends Bloc<GenderEvent, GenderState> {
  GenderBloc() : super(GenderInitial()) {
    on<GenderSelected>((event, emit) {
      emit(GenderSelectedState(event.selectedGender));
    });

    on<GenderCleared>(_onGenderCleared);
  }

  void _onGenderCleared(GenderCleared event, Emitter<GenderState> emit) {
    emit(GenderInitial());
  }
}
