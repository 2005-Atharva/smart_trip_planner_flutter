// lib/src/features/home/home_screen.dart  (only the changed parts)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_trip_planner_flutter/src/core/device/device.dart';
import 'package:smart_trip_planner_flutter/src/features/auth/widgets/auth_button.dart';
import 'package:smart_trip_planner_flutter/src/features/chat/pages/chat_screen.dart';
import 'package:smart_trip_planner_flutter/src/features/home/bloc/chat_bloc.dart';
import 'package:smart_trip_planner_flutter/src/features/home/models/itinerary_models.dart';
import 'package:smart_trip_planner_flutter/src/features/chat/widgets/chat_msg.dart';

class UserOptionScreen extends StatefulWidget {
  final TextEditingController userInputtext;
  const UserOptionScreen({super.key, required this.userInputtext});
  @override
  State<UserOptionScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<UserOptionScreen> {
  bool text = false;

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(
      ChatButtonPressed(userMessage: widget.userInputtext.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MyDevices.getScreenHeight(context);
    final width = MyDevices.getScreenWidth(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 247),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 245, 247),
        title: Text(
          'Home',
          style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 22),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(255, 6, 95, 70),
                ),
                alignment: Alignment.center,
                child: Text(
                  'S',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          final bool loading = state is ChatLoadingState;
          final List<ChatMessage> messages = switch (state) {
            ChatSuccessState s => s.messagesDetail,
            ChatInitial s => s.message,
            _ => const [],
          };
          if (state is ChatLoadingState) {
            Container(height: 100, color: Colors.red);
            CircularProgressIndicator();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.15),
                child: loading
                    ? Text(
                        'Creating Itinerary...',
                        style: GoogleFonts.inter(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        'Itinerary Created 🏝',
                        style: GoogleFonts.inter(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
              SizedBox(height: height * 0.02),

              if (loading)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    alignment: Alignment.center,

                    height: 300,
                    width: double.maxFinite,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(blurRadius: 6, color: Colors.black12),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: const Color.fromARGB(255, 6, 95, 70),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Curating a perfect plan for you...',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

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
                        return _UserBubble(text: m.text);
                      case Sender.ai:
                        // When payload is Itinerary, show a compact card; else plain text.
                        if (m.payload is Itinerary) {
                          final iti = m.payload as Itinerary;
                          return AiItineraryCard(iti: iti);
                        }
                        return _AiBubble(text: m.text);
                      case Sender.error:
                        return _ErrorBubble(text: m.text);
                    }
                  },
                ),
              ),

              AuthButton(
                loading: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(userInputtext: widget.userInputtext),
                    ),
                  );
                },
                title: 'Follow up to refine',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  height: 60,
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download_rounded),
                      SizedBox(width: 4),
                      Text(
                        'Save Offline',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }
}

// Simple bubbles/cards
class _UserBubble extends StatelessWidget {
  final String text;
  const _UserBubble({required this.text});
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
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 12),
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

class _AiBubble extends StatelessWidget {
  final String text;
  const _AiBubble({required this.text});
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

class _ErrorBubble extends StatelessWidget {
  final String text;
  const _ErrorBubble({required this.text});
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.center,
    child: Text(text, style: const TextStyle(color: Colors.red)),
  );
}

class AiItineraryCard extends StatelessWidget {
  final Itinerary iti;
  const AiItineraryCard({required this.iti});

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
                  child: Icon(Icons.chat_bubble, size: 16, color: Colors.white),
                ),
                SizedBox(width: 12),
                Text(
                  'Itinera AI',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
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

            // All days
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
                    // All items per day
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: day.items
                          .map(
                            (i) => Text(
                              '• ${i.time}  ${i.activity}  (${i.location})',
                            ),
                          )
                          .toList(),
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
