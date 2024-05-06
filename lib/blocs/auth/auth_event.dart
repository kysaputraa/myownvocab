part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthEventLogin extends AuthEvent {
  String email;
  String password;
  AuthEventLogin({required this.email, required this.password});
}

class AuthEventSetLogin extends AuthEvent {
  String uid;
  String email;
  AuthEventSetLogin({required this.uid, required this.email});
}

class AuthEventRegister extends AuthEvent {
  String email;
  String password;
  String firstName;
  String lastName;
  AuthEventRegister({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });
}

class AuthEventLogout extends AuthEvent {}
