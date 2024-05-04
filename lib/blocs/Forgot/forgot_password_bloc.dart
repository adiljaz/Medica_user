import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotClickEvent>((event, emit) async {
      emit(ForgotpasswordLoading()); // Corrected state name
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: event.email.trim());
        emit(ForgotpasswordDone()); // Corrected state name
      } catch (e) {
        emit(ForgotpasswordError()); // Corrected state name
      }
    });
  }
}
