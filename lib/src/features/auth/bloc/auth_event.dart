part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class LoginWithMailButtonPressed extends AuthEvent {
  final String email;
  final String password;

  LoginWithMailButtonPressed({required this.email, required this.password});
}

final class CreateWithMailButtonPressed extends AuthEvent {
  final String email;
  final String password;
  final String password2;

  CreateWithMailButtonPressed({
    required this.email,
    required this.password,
    required this.password2,
  });
}

final class LogoutEvent extends AuthEvent {}

final class LoginWithGoogleButtonPressed extends AuthState {}
