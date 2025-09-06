part of 'obscuretext_bloc.dart';

@immutable
sealed class ObscuretextState {}

final class ObscuretextInitial extends ObscuretextState {
  final bool value;

  ObscuretextInitial({required this.value});
}
