import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_trip_planner_flutter/src/features/hive/data/offline_chats_repository.dart';
import 'package:smart_trip_planner_flutter/src/features/home/services/gemini_service.dart';
import 'package:smart_trip_planner_flutter/src/features/home/models/itinerary_models.dart';
import 'package:smart_trip_planner_flutter/src/features/chat/widgets/chat_msg.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GeminiService gemini;
  final List<ChatMessage> _messages = [];
  final OfflineChatsRepository offline;
  ChatBloc(this.gemini, this.offline) : super(ChatInitial(message: [])) {
    on<ChatButtonPressed>(_onChatButtonPressed);
    on<SaveOfflinePressed>(_onSaveOfflinePressed);
  }

  Future<void> _onChatButtonPressed(
    ChatButtonPressed event,
    Emitter<ChatState> emit,
  ) async {
    final prompt = event.userMessage.trim();
    if (prompt.isEmpty) return;

    _messages.add(ChatMessage.user(prompt));
    emit(ChatLoadingState());

    try {
      final Itinerary iti = await gemini.generateItinerary(prompt);

      _messages.add(ChatMessage.ai(iti.title, payload: iti));

      print('Success');
      emit(ChatSuccessState(messagesDetail: List.unmodifiable(_messages)));
    } catch (e) {
      _messages.add(ChatMessage.error('Failed to generate itinerary: $e'));
      emit(ChatFailureState(message: e.toString()));
      emit(ChatSuccessState(messagesDetail: List.unmodifiable(_messages)));
    }
  }

  Future<void> _onSaveOfflinePressed(
    SaveOfflinePressed event,
    Emitter<ChatState> emit,
  ) async {
    if (_messages.isEmpty) return;
    try {
      await offline.saveChat(_messages);
    } catch (e) {
      print('error');
    }
  }
}
