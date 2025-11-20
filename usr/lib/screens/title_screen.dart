import 'package:flutter/material.dart';
import 'package:couldai_user_app/game_engine/game_state.dart';

class TitleScreen extends StatelessWidget {
  const TitleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.auto_fix_high,
                size: 80,
                color: Colors.cyanAccent,
              ),
              const SizedBox(height: 20),
              Text(
                "NEON & SORCERY",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.purpleAccent,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                  fontFamily: 'Courier',
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Where Cyberpunk meets High Fantasy",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  GameState().resetGame();
                  Navigator.pushReplacementNamed(context, '/game');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent.withOpacity(0.8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                    side: const BorderSide(color: Colors.cyanAccent, width: 2),
                  ),
                ),
                child: const Text("INITIALIZE LINK"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
