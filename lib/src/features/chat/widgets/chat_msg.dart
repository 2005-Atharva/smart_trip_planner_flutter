// lib/src/features/chat/models/chat_message.dart
enum Sender { user, ai, error }

class ChatMessage {
  final Sender sender;
  final String text; // raw text that you show in the chat bubble
  final DateTime ts;
  final dynamic payload;

  ChatMessage.user(this.text)
    : sender = Sender.user,
      ts = DateTime.now(),
      payload = null;
  ChatMessage.ai(this.text, {this.payload})
    : sender = Sender.ai,
      ts = DateTime.now();
  ChatMessage.error(this.text)
    : sender = Sender.error,
      ts = DateTime.now(),
      payload = null;
}
