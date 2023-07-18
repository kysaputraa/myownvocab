import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    FirebaseAuth auth = FirebaseAuth.instance;

    on<AuthEventLogin>((event, emit) async {
      try {
        emit(AuthLoading());
        await auth.signInWithEmailAndPassword(
            email: event.email.toString(), password: event.password);
        emit(AuthSuccess());
      } on FirebaseAuthException catch (e) {
        emit(AuthError(message: e.message.toString()));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<AuthEventLogout>((event, emit) async {
      try {
        emit(AuthLoading());
        auth.signOut();
        emit(AuthLogout());
      } on FirebaseAuthException catch (e) {
        emit(AuthError(message: e.message.toString()));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });
  }
}
