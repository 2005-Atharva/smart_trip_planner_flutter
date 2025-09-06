import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TripInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onMicPressed;
  final int maxLines;
  const TripInputField({
    Key? key,
    required this.controller,
    this.onMicPressed,
    required this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.teal, // green border color
            width: 1.5,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: maxLines,

                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  border: InputBorder.none,
                  hintText: "Describe your trip...",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromARGB(255, 8, 23, 53),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: onMicPressed,
              icon: const Icon(Icons.mic, color: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}
