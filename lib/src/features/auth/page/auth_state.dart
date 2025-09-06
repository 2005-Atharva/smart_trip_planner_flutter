import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_trip_planner_flutter/src/features/auth/page/login_screen.dart';
import 'package:smart_trip_planner_flutter/src/features/home/pages/home_screeen.dart';
import 'package:smart_trip_planner_flutter/src/features/chat/pages/chat_screen.dart';

class AuthStateChecker extends StatefulWidget {
  const AuthStateChecker({super.key});

  @override
  State<AuthStateChecker> createState() => _AuthStateCheckerState();
}

class _AuthStateCheckerState extends State<AuthStateChecker> {
  late Stream<User?> _authStateStream;

  @override
  void initState() {
    super.initState();
    _authStateStream = FirebaseAuth.instance.idTokenChanges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: _authStateStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            // return HomeScreen();
            return HomeScreeen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
