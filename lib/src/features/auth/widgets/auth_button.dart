import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.loading,
  });
  final String title;
  final void Function() onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 6, 95, 70), // button background
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color.fromRGBO(25, 22, 20, 0.05), // light border
              width: 1,
            ),
            boxShadow: [
              // Shadow 1 (purple glow)
              BoxShadow(
                color: const Color.fromRGBO(
                  154,
                  106,
                  214,
                  0.3,
                ), // adjust opacity
                offset: const Offset(0, 12),
                blurRadius: 32,
                spreadRadius: 3,
              ),
              // Shadow 2 (white soft highlight)
              BoxShadow(
                color: const Color.fromRGBO(255, 250, 247, 0.8),
                offset: const Offset(0, 4),
                blurRadius: 4,
                spreadRadius: -2,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: loading
              ? CircularProgressIndicator(color: Colors.white)
              : Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
