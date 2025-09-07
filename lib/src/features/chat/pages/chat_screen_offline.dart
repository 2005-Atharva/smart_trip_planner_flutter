// lib/src/features/chat/pages/chat_screen_read_only.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_trip_planner_flutter/src/core/device/device.dart';
import 'package:smart_trip_planner_flutter/src/features/home/models/itinerary_models.dart';
import 'package:smart_trip_planner_flutter/src/features/chat/widgets/chat_msg.dart';

class ChatScreenReadOnly extends StatelessWidget {
  final List<ChatMessage> messages;
  const ChatScreenReadOnly({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    final height = MyDevices.getScreenHeight(context);
    final width = MyDevices.getScreenWidth(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 247),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 245, 247),
        title: Text(
          'Saved Chat',
          style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
      body: messages.isEmpty
          ? Center(
              child: Text(
                "No messages in this chat",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.02),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (_, i) {
                      final m = messages[i];
                      switch (m.sender) {
                        case Sender.user:
                          return _UserBubbleRO(text: m.text);
                        case Sender.error:
                          return _ErrorBubbleRO(text: m.text);
                        case Sender.ai:
                          final Itinerary? iti = _asItinerary(m.payload);
                          if (iti != null) {
                            return _AiItineraryCardRO(iti: iti);
                          }
                          return _AiBubbleRO(text: m.text);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
    );
  }

  Itinerary? _asItinerary(dynamic payload) {
    if (payload == null) return null;
    if (payload is Itinerary) return payload;
    if (payload is Map<String, dynamic>) {
      try {
        return Itinerary.fromJson(payload);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}

class _UserBubbleRO extends StatelessWidget {
  final String text;
  const _UserBubbleRO({required this.text});

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.center,
    child: Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(255, 6, 95, 70),
                ),
                alignment: Alignment.center,
                child: Text(
                  'S',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'You',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _AiBubbleRO extends StatelessWidget {
  final String text;
  const _AiBubbleRO({required this.text});
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.center,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
  );
}

class _ErrorBubbleRO extends StatelessWidget {
  final String text;
  const _ErrorBubbleRO({required this.text});
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.center,
    child: Text(text, style: const TextStyle(color: Colors.red)),
  );
}

class _AiItineraryCardRO extends StatelessWidget {
  final Itinerary iti;
  const _AiItineraryCardRO({required this.iti});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 255, 200, 0),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.chat_bubble,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Itinera AI',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              iti.title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              '${iti.startDate} — ${iti.endDate}',
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 12),

            // All days + items (read-only)
            ListView.separated(
              shrinkWrap: true,
              primary: false,
              itemCount: iti.days.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, d) {
                final day = iti.days[d];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Day ${d + 1}: ${day.summary}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    ...day.items.map(
                      (i) =>
                          Text('• ${i.time}  ${i.activity}  (${i.location})'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
