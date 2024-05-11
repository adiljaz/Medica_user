import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'edit_user_event.dart';
part 'edit_user_state.dart';

class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  EditUserBloc() : super(EditUserInitial()) {
    on<EditUserClick>((event, emit) async {
      emit(EditUserLoading());

      try {
        final CollectionReference user =
            FirebaseFirestore.instance.collection('users');
        user.doc(event.uid).update(event.data);

        emit(EditUserSucces());
      } catch (error) {
        emit(EditUserErroState(error: error.toString()));
      }
    });
  }
}



// Future<void> editStudentClicked(documentid, data) async {
//   final CollectionReference user =
//       FirebaseFirestore.instance.collection('users');
//   try {
//     await user.doc(documentid).update(data);

//     print('successsssssssssssssssssss');
//   } catch (e) {
//     print(e);
//   }
// }

