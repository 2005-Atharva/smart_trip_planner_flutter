import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_trip_planner_flutter/src/core/device/device.dart';
import 'package:smart_trip_planner_flutter/src/features/chat/widgets/Aitinerary_card.dart';
import 'package:smart_trip_planner_flutter/src/features/chat/widgets/chat_bubbles.dart';
import 'package:smart_trip_planner_flutter/src/features/chat/widgets/error_bubble.dart';
import 'package:smart_trip_planner_flutter/src/features/home/bloc/chat_bloc.dart';
import 'package:smart_trip_planner_flutter/src/features/home/models/itinerary_models.dart';
import 'package:smart_trip_planner_flutter/src/features/chat/widgets/chat_msg.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatScreen extends StatefulWidget {
  final TextEditingController userInputtext;
  const ChatScreen({super.key, required this.userInputtext});
  @override
  State<ChatScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ChatScreen> {
  bool text = false;
  late stt.SpeechToText _speech;
  bool _speechEnabled = false;
  bool _isListening = false;

  final TextEditingController _userQuery = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(
      ChatButtonPressed(userMessage: widget.userInputtext.text.trim()),
    );
    _initSpeech();
  }

  Future<bool> _checkMicPermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
    }
    return status.isGranted;
  }

  Future<void> _initSpeech() async {
    _speech = stt.SpeechToText();
    _speechEnabled = await _speech.initialize(
      onStatus: (status) {
        // when user stops talking automatically
        if (status == "done") {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        debugPrint("Speech error: $error");
      },
    );
    setState(() {});
  }

  void _toggleListening() async {
    if (!_speechEnabled) return;

    bool granted = await _checkMicPermission();
    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Microphone permission required")),
      );
      return;
    }

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    } else {
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _userQuery.text = result.recognizedWords;
          });
        },
        // ignore: deprecated_member_use
        listenMode: stt.ListenMode.dictation,
        localeId: "en_US",
      );
      setState(() => _isListening = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MyDevices.getScreenHeight(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 247),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 245, 247),
        title: Text(
          'Chat',
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

              if (loading)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 300,
                    width: double.maxFinite,
                    alignment: Alignment.center,
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
                            'Crating a perfect plan for you...',
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
                        return UserBubble(text: m.text);
                      case Sender.ai:
                        // When payload is Itinerary, show a compact card; else plain text.
                        if (m.payload is Itinerary) {
                          final iti = m.payload as Itinerary;
                          return AiItineraryCard(iti: iti);
                        }
                        return AiBubble(text: m.text);
                      case Sender.error:
                        return ErrorBubble(text: m.text);
                    }
                  },
                ),
              ),

              // Input
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _userQuery,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true,
                          border: InputBorder.none,
                          hintText: "Follow up to refine",
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromARGB(255, 8, 23, 53),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide(
                              color: Color.fromARGB(
                                255,
                                6,
                                95,
                                70,
                              ), // green border color
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide(
                              color: Color.fromARGB(
                                255,
                                6,
                                95,
                                70,
                              ), // green border color
                              width: 1.5,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.mic,
                              color: Color.fromARGB(255, 6, 95, 70),
                              size: 22,
                            ),
                            onPressed: _toggleListening,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        final prompt = _userQuery.text.trim();
                        context.read<ChatBloc>().add(
                          ChatButtonPressed(userMessage: prompt),
                        );
                        _userQuery.clear();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color.fromARGB(255, 6, 95, 70),
                        ),
                        alignment: Alignment.center,
                        child: loading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Image.asset('assets/icons/Send.png', scale: 1),
                      ),
                    ),
                  ],
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
