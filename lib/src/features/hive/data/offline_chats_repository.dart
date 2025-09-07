import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_trip_planner_flutter/src/features/chat/widgets/chat_msg.dart';

class OfflineChatsRepository {
  final Box<String> _box;
  OfflineChatsRepository(this._box);

  Future<String> saveChat(List<ChatMessage> messages) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final payload = jsonEncode({
      "id": id,
      "createdAt": DateTime.now().toIso8601String(),
      "messages": messages.map(_messageToJson).toList(),
    });
    await _box.put(id, payload);
    return id;
  }

  List<Map<String, dynamic>> listSummaries() {
    return _box.values.map((s) {
      final map = jsonDecode(s) as Map<String, dynamic>;
      final msgs = (map["messages"] as List);
      // try to find AI itinerary title or fall back to first user msg
      final aiWithTitle = msgs.firstWhere(
        (m) => m["sender"] == "ai" && m["payload"]?["title"] != null,
        orElse: () => null,
      );
      final title = aiWithTitle != null
          ? aiWithTitle["payload"]["title"] as String
          : (msgs.isNotEmpty
                ? msgs.firstWhere(
                    (m) => m["sender"] == "user",
                    orElse: () => {"text": "Saved chat"},
                  )["text"]
                : "Saved chat");

      return {"id": map["id"], "createdAt": map["createdAt"], "title": title};
    }).toList();
  }

  List<ChatMessage> loadChat(String id) {
    final s = _box.get(id);
    if (s == null) return [];
    final map = jsonDecode(s) as Map<String, dynamic>;
    final list = (map["messages"] as List).cast<Map<String, dynamic>>();
    return list.map(_messageFromJson).toList();
  }

  Map<String, dynamic> _messageToJson(ChatMessage m) {
    return {
      "sender": _senderToString(m.sender),
      "text": m.text,
      "ts": m.ts.toIso8601String(),
      "payload": _payloadToJson(m.payload),
    };
  }

  ChatMessage _messageFromJson(Map<String, dynamic> j) {
    final sender = _senderFromString(j["sender"] as String);
    final text = j["text"] as String? ?? "";
    final payload = j["payload"]; // may be null or itinerary map
    if (sender == Sender.user) return ChatMessage.user(text);
    if (sender == Sender.error) return ChatMessage.error(text);
    return ChatMessage.ai(
      text,
      payload: payload,
    ); // you already render Itinerary if map matches
  }

  String _senderToString(Sender s) {
    switch (s) {
      case Sender.user:
        return "user";
      case Sender.ai:
        return "ai";
      case Sender.error:
        return "error";
    }
  }

  Sender _senderFromString(String s) {
    switch (s) {
      case "user":
        return Sender.user;
      case "ai":
        return Sender.ai;
      case "error":
        return Sender.error;
      default:
        return Sender.user;
    }
  }

  dynamic _payloadToJson(dynamic p) {
    try {
      final iti = p;
      if (iti == null) return null;
      if (iti is Map<String, dynamic>) return iti; // already map
      if (iti.title != null && iti.days != null) {
        return {
          "title": iti.title,
          "startDate": iti.startDate,
          "endDate": iti.endDate,
          "days": iti.days
              .map(
                (d) => {
                  "date": d.date,
                  "summary": d.summary,
                  "items": d.items
                      .map(
                        (i) => {
                          "time": i.time,
                          "activity": i.activity,
                          "location": i.location,
                        },
                      )
                      .toList(),
                },
              )
              .toList(),
        };
      }
    } catch (_) {}
    return null;
  }
}
