part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthLogout extends AuthState {}

class AuthError extends AuthState {
  String message;
  AuthError({required this.message});
}
