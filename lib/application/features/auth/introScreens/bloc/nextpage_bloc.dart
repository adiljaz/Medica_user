// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'nextpage_event.dart';
part 'nextpage_state.dart';

class NextpageBloc extends Bloc<NextpageEvent, NextpageState> {
  NextpageBloc() : super(NextpageInitial()) {
    on<CheckNextClickEvent>((event, emit) async {
      try {
        if (event.pageTwo == false) {
          emit(Skip());
        }
        if (event.pageTwo == true) {
          emit(OnclickDone(done: 'Done'));
        }
      } catch (e) {
        emit(OnclickNotDone(e.toString()));
      }
    });
  }
}
