import 'package:flutter/material.dart';
import 'package:couldai_user_app/screens/title_screen.dart';
import 'package:couldai_user_app/screens/adventure_screen.dart';

void main() {
  runApp(const TechnoFantasyApp());
}

class TechnoFantasyApp extends StatelessWidget {
  const TechnoFantasyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neon & Sorcery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.cyanAccent,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyanAccent,
          secondary: Colors.purpleAccent,
          surface: Color(0xFF1E1E1E),
          onSurface: Colors.white,
        ),
        fontFamily: 'Courier', // Monospaced for that retro/terminal feel
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TitleScreen(),
        '/game': (context) => const AdventureScreen(),
      },
    );
  }
}
