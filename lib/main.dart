import 'package:d_m/app/modules/splash_screen.dart';
import 'package:flutter/material.dart';
import 'app/modules/civilian_dashboard/views/civilian_dashboard_view.dart';
import 'app/modules/predictive_ai/views/predictive_ai_page.dart';
import 'app/modules/learn/views/learn_page.dart';
import 'app/modules/refugee_camp/views/refugee_camp_page.dart';
import 'app/modules/sos/views/sos_page.dart';
import 'app/modules/user_guide/views/user_guide_page.dart';
import 'app/modules/call/views/call_page.dart';
import 'app/modules/profile/views/profile_page.dart';
import 'app/modules/community_history/views/community_history_page.dart';
import 'app/modules/ai_chatbot.dart';
import 'package:flutter_gemini/flutter_gemini.dart'; // Import Gemini
import 'package:firebase_core/firebase_core.dart';

void main() async {
  print("Initializing app...");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print("Firebase initialized");
  Gemini.init(apiKey: 'AIzaSyADGh1jYjjOA5hNJVVFUzBwNZ-SVMYdqXc');
  print("Gemini initialized");
  runApp(const MyApp());
  print("App started");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Define the named routes here.
  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => const SplashScreen(), // Set splash screen as initial route
    '/civilian_dashboard': (context) => const CivilianDashboardView(),
    '/predictive_ai': (context) => const PredictiveAIPage(),
    '/learn': (context) => const LearnPage(),
    '/refugee_camp': (context) => const RefugeeCampPage(),
    '/sos': (context) => const SOSPage(),
    '/user_guide': (context) => const UserGuidePage(),
    '/call': (context) => CallPage(),
    '/profile': (context) =>  ProfilePage(),
    '/community_history': (context) => const CommunityHistoryPage(),
    '/ai_chatbot': (context) => AIChatbotScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disaster Management App',
      debugShowCheckedModeBanner: false,
      routes: routes,
      initialRoute: '/', // Set splash screen as the initial route
    );
  }
}