import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpacerWidget extends StatelessWidget {
  final String title;
  const SpacerWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.grey.shade400,
              thickness: 1,
              endIndent: 10,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 14),
          ),
          Expanded(
            child: Divider(
              color: Colors.grey.shade400,
              thickness: 1,
              indent: 10,
            ),
          ),
        ],
      ),
    );
  }
}
