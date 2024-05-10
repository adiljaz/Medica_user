import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/repository/googlerepo/repo.dart';
import 'package:meta/meta.dart';

part 'google_auth_event.dart';
part 'google_auth_state.dart';

class GoogleAuthBloc extends Bloc<GoogleAuthEvent, GoogleAuthState> {
  GoogleAuthBloc() : super(GoogleAuthInitial()) {
    on<SigninEvent>(_sihningWithGoogle);
  }

  final AuthRepo authrepository = AuthRepo();

  Future<void> _sihningWithGoogle(
      SigninEvent event, Emitter<GoogleAuthState> emit) async {
    // final user = await _authRepo.sihningWithGoogle();

    emit(GoogleAuthPendingn());

    final user = await authrepository.signinWithGoogle();
    if (user != null) {
      final name = user.email?.split('@').first;
      FirebaseFirestore.instance.collection('users auth').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'name': name,
      });
      emit(GoogleAuthsuccess());
    }
    emit(GoogleAuthError());
  }
}
