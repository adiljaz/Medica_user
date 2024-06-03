import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'department_event.dart';
part 'department_state.dart';

class GenderBloc extends Bloc<GenderEvent, GenderState> {
  GenderBloc() : super(GenderInitial()) {
    on<GenderSelected>((event, emit) {

      emit(GenderSelectedState(selectedGender: event.selecteGender));
   
    });
  }
}
