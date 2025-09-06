part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthSuccessState extends AuthState {
  final User user;

  AuthSuccessState({required this.user});
}

final class AuthLoading extends AuthState {}

final class AuthErrorState extends AuthState {
  final String err;

  AuthErrorState({required this.err});
}
