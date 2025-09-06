part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {
  final List<ChatMessage> message;

  ChatInitial({required this.message});
}

final class ChatLoadingState extends ChatState {}

final class ChatSuccessState extends ChatState {
  final List<ChatMessage> messagesDetail;

  ChatSuccessState({required this.messagesDetail});
}

final class ChatFailureState extends ChatState {
  final String message;

  ChatFailureState({required this.message});
}
