import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    FirebaseAuth auth = FirebaseAuth.instance;
    SharedPreferences prefs;

    on<AuthEventLogin>((event, emit) async {
      try {
        emit(AuthLoading());
        await auth
            .signInWithEmailAndPassword(
                email: event.email.toString(), password: event.password)
            .then(
          (value) async {
            prefs = await SharedPreferences.getInstance();
            prefs.setString("uid", value.user!.uid);
            prefs.setString("email", value.user!.email.toString());
            emit(AuthSuccess(
                uid: value.user!.uid, email: value.user!.email.toString()));
          },
        );
      } on FirebaseAuthException catch (e) {
        emit(AuthError(message: e.message.toString()));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<AuthEventSetLogin>((event, emit) async {
      try {
        emit(AuthLoading());
        emit(AuthSuccess(uid: event.uid, email: event.email));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<AuthEventRegister>((event, emit) async {
      try {
        emit(AuthLoading());
        await auth
            .createUserWithEmailAndPassword(
                email: event.email, password: event.password)
            .then((res) async {
          await FirebaseFirestore.instance.collection('uid').add({
            'first_name': event.firstName,
            'last_name': event.lastName,
            'email': event.email,
          });
          emit(AuthSuccessSignUp());
        });
      } on FirebaseAuthException catch (e) {
        emit(AuthError(message: e.message.toString()));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<AuthEventLogout>((event, emit) async {
      try {
        emit(AuthLoading());
        await auth.signOut().then((value) async {
          prefs = await SharedPreferences.getInstance();
          prefs.clear();
        });
        emit(AuthLogout());
      } on FirebaseAuthException catch (e) {
        emit(AuthError(message: e.message.toString()));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });
  }
}
