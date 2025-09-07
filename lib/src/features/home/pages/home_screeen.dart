import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_trip_planner_flutter/src/core/device/device.dart';
import 'package:smart_trip_planner_flutter/src/features/auth/widgets/auth_button.dart';
import 'package:smart_trip_planner_flutter/src/features/chat/pages/chat_screen_offline.dart';
import 'package:smart_trip_planner_flutter/src/features/chat/pages/user_option_screen.dart';
import 'package:smart_trip_planner_flutter/src/features/hive/data/offline_chats_repository.dart';
import 'package:smart_trip_planner_flutter/src/features/home/widget/textfield_widget.dart';
import 'package:smart_trip_planner_flutter/src/features/profile/pages/profile_screen.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeScreeen extends StatefulWidget {
  const HomeScreeen({super.key});

  @override
  State<HomeScreeen> createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
  final TextEditingController usertextHome = TextEditingController();
  List<Map<String, dynamic>> _saved = [];

  late stt.SpeechToText _speech;
  bool _speechEnabled = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    final repo = OfflineChatsRepository(Hive.box<String>('offline_chats'));
    setState(() {
      _saved = repo.listSummaries();
    });
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
            usertextHome.text = result.recognizedWords;
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
    final width = MyDevices.getScreenWidth(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 247),
      appBar: AppBar(
        title: Text(
          'Hey Shubham 👋',
          style: GoogleFonts.inter(
            fontSize: 24,
            color: const Color.fromARGB(255, 6, 95, 70),
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 22),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.04),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.15),
              child: Text(
                'What’s your vision for this trip?',
                style: GoogleFonts.inter(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: height * 0.04),

            // Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TripInputField(
                maxLines: 5,
                controller: usertextHome,
                onMicPressed: _toggleListening,
              ),
            ),
            SizedBox(height: height * 0.04),

            AuthButton(
              loading: false,
              title: "Create My Itinerary",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserOptionScreen(userInputtext: usertextHome),
                  ),
                );
              },
            ),
            SizedBox(height: height * 0.04),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.15),
              child: Text(
                'Offline Saved Itineraries',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: height * 0.04),

            Column(
              children: _saved.map((s) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color.fromARGB(255, 6, 95, 70),
                      ),
                    ),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    title: Text(s['title'] ?? 'Saved chat'),
                    onTap: () {
                      // load full chat and navigate to a read-only page or reuse chat page
                      final repo = OfflineChatsRepository(
                        Hive.box<String>('offline_chats'),
                      );
                      final msgs = repo.loadChat(s['id']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreenReadOnly(messages: msgs),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
