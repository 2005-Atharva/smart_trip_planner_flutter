import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_trip_planner_flutter/src/features/home/services/gemini_service.dart';
import 'package:smart_trip_planner_flutter/src/features/home/models/itinerary_models.dart';
import 'package:smart_trip_planner_flutter/src/features/chat/widgets/chat_msg.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GeminiService gemini;
  final List<ChatMessage> _messages = [];
  ChatBloc(this.gemini) : super(ChatInitial(message: [])) {
    on<ChatButtonPressed>(_onChatButtonPressed);
  }

  Future<void> _onChatButtonPressed(
    ChatButtonPressed event,
    Emitter<ChatState> emit,
  ) async {
    final prompt = event.userMessage.trim();
    if (prompt.isEmpty) return;

    // 1) add user's message immediately
    _messages.add(ChatMessage.user(prompt));
    emit(ChatLoadingState()); // UI shows the loader (Creating itinerary…)

    try {
      // 2) call Gemini → parse Spec-A → get Itinerary
      final Itinerary iti = await gemini.generateItinerary(prompt);

      // 3) add AI reply carrying the itinerary payload
      _messages.add(ChatMessage.ai(iti.title, payload: iti));

      // 4) success: expose the full chat list to UI
      print('Success');
      emit(ChatSuccessState(messagesDetail: List.unmodifiable(_messages)));
    } catch (e) {
      // 5) failure: push an error bubble and emit failure
      _messages.add(ChatMessage.error('Failed to generate itinerary: $e'));
      emit(ChatFailureState(message: e.toString()));
      // optional: also show the updated list after failure:
      emit(ChatSuccessState(messagesDetail: List.unmodifiable(_messages)));
    }
  }
}
