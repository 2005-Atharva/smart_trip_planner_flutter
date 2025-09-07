import 'package:flutter/material.dart';

class UserCart extends StatelessWidget {
  const UserCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        height: 340,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.green[700],
                    child: const Text(
                      "S",
                      style: TextStyle(fontSize: 26, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "test1",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "test1@gmail.com",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),

              // Request Tokens
              const Text("Request Tokens"),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: 130 / 1000,
                color: Colors.green,
                backgroundColor: Colors.grey[300],
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerRight,
                child: Text("130/1000"),
              ),

              const SizedBox(height: 16),

              // Response Tokens
              const Text("Response Tokens"),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: 275 / 1000,
                color: Colors.red,
                backgroundColor: Colors.grey[300],
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerRight,
                child: Text("275/1000"),
              ),

              const SizedBox(height: 20),

              // Total Cost
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Total Cost",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$0.07 USD",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
