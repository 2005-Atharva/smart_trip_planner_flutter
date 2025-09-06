part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

final class ChatButtonPressed extends ChatEvent {
  final String userMessage;

  ChatButtonPressed({required this.userMessage});
}
