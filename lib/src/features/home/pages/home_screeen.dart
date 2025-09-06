import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_trip_planner_flutter/src/core/device/device.dart';
import 'package:smart_trip_planner_flutter/src/features/auth/widgets/auth_button.dart';
import 'package:smart_trip_planner_flutter/src/features/chat/pages/chat_screen.dart';
import 'package:smart_trip_planner_flutter/src/features/chat/pages/user_option_screen.dart';
import 'package:smart_trip_planner_flutter/src/features/home/widget/textfield_widget.dart';

class HomeScreeen extends StatefulWidget {
  const HomeScreeen({super.key});

  @override
  State<HomeScreeen> createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
  final TextEditingController usertextHome = TextEditingController();

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
                onMicPressed: () {},
              ),
            ),
            SizedBox(height: height * 0.04),

            AuthButton(
              loading: false,
              title: "Create My Itinerary",
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) =>
                //         ChatScreen(userInputtext: usertextHome),
                //   ),
                // );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserOptionScreen(userInputtext: usertextHome),
                  ),
                );
                // usertextHome.clear();
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

            OfflineCart(
              height: height,
              title: "This is the data is shown into the model",
            ),
          ],
        ),
      ),
    );
  }
}

class OfflineCart extends StatelessWidget {
  const OfflineCart({super.key, required this.height, required this.title});

  final double height;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        height: height * 0.05,
        width: double.maxFinite,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(77, 238, 238, 238),
              offset: const Offset(0, 12),
              blurRadius: 32,
              spreadRadius: 3,
            ),
            BoxShadow(
              color: const Color.fromRGBO(255, 250, 247, 0.8),
              offset: const Offset(0, 4),
              blurRadius: 4,
              spreadRadius: -2,
            ),
          ],
        ),
        child: Text(
          title,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }
}
