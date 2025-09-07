import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_trip_planner_flutter/app.dart';
import 'package:smart_trip_planner_flutter/firebase_options.dart';
import 'package:smart_trip_planner_flutter/src/features/auth/bloc/auth_bloc.dart';
import 'package:smart_trip_planner_flutter/src/features/auth/bloc/obscuretext_bloc.dart';
import 'package:smart_trip_planner_flutter/src/features/hive/data/offline_chats_repository.dart';
import 'package:smart_trip_planner_flutter/src/features/home/bloc/chat_bloc.dart';
import 'package:smart_trip_planner_flutter/src/features/home/services/gemini_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await dotenv.load(fileName: '.env');
  // final apiKey = dotenv.env['GEMINI_API_KEY']!;
  const apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'your api key',
  );
  await Hive.initFlutter();
  await Hive.openBox<String>('offline_chats');
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ObscuretextBloc()),
        BlocProvider(create: (context) => AuthBloc()),

        BlocProvider(
          create: (context) => ChatBloc(
            GeminiService(apiKey: apiKey),
            OfflineChatsRepository(Hive.box<String>('offline_chats')),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
