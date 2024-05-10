import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'edit_user_event.dart';
part 'edit_user_state.dart';

class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  EditUserBloc() : super(EditUserInitial()) {
    on<EditUserEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
