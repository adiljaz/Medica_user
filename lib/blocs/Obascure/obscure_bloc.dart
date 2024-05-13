import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'obscure_event.dart';
part 'obscure_state.dart';

class ObscureBloc extends Bloc<ObscureEvent, ObscureState> {
  ObscureBloc() : super(ObscureInitial()) {
    on<ObscureCLick>((event, emit) {
      if (event.obscure) {
        emit(Obscurtrue());
        print('trueeeeeeeeeeeeeee00');
      } else {
        emit(ObscurFalse());
         print('falseeeeeeeeeeeeeee');
      }
    });
  }
}
