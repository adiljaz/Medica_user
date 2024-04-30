// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/application/features/auth/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthBloc() : super(AuthInitial()) {
    on<CheckLoginStatusEvent>((event, emit) async {
      User? user;

      try {
        await Future.delayed(Duration(seconds: 2), () {
          user = _auth.currentUser;
        });

        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(UnAuthenticated());
        }
      } catch (e) {
        emit(AuthenticatedError(e.toString()));
      }
    });

    on<SignupEvent>((event, emit) async {
      emit(AuthLoading()); // Inform UI about loading state

      try {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: event.user.email.toString(),
          password: event.user.password.toString(),
        );

        final user = userCredential.user;

        if (user != null) {
          // Create user document in Firestore with proper data handling
          final userData = {
            'uid': user.uid,
            'email': user.email,
            'name': event.user.userName?.trim() ?? 'Anonymous',
            'createdAt': DateTime.now(),
          };

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(userData);
          emit(Authenticated(user)); // Emit success with user data
        } else {
          emit(UnAuthenticated()); // Emit failure without user data
        }
      } catch (e) {
        // Log specific error and emit a more informative error event
        print('Signup Error: $e');
        emit(AuthenticatedError(e.toString())); // Use helper function
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        final userCredential = await _auth.signInWithEmailAndPassword(
            email: event.email, password: event.password);

        final user = userCredential.user;
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(UnAuthenticated());
        }
      } catch (e) {
        emit(AuthenticatedError(e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      try {
        await _auth.signOut();
        emit(UnAuthenticated());
      } catch (e) {
        emit(AuthenticatedError(e.toString()));
      }
    });
  }
}
