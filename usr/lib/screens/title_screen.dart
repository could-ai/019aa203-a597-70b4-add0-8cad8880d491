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
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => _showHowToPlay(context),
                child: const Text(
                  "HOW TO PLAY",
                  style: TextStyle(color: Colors.cyanAccent, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHowToPlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("MANUAL_OVERRIDE.TXT", style: TextStyle(color: Colors.cyanAccent)),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("OBJECTIVE:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text("Survive, explore, and level up in a world of magic and machines.", style: TextStyle(color: Colors.white70)),
              SizedBox(height: 10),
              Text("CONTROLS:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text("• TRAVEL: Move to a new location. Risk of enemy encounter.", style: TextStyle(color: Colors.white70)),
              Text("• ATTACK: Basic physical damage.", style: TextStyle(color: Colors.white70)),
              Text("• SPELL: High damage, costs Energy.", style: TextStyle(color: Colors.white70)),
              Text("• SCAVENGE: Search for credits or potions.", style: TextStyle(color: Colors.white70)),
              SizedBox(height: 10),
              Text("TIPS:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text("• Don't travel while in combat.", style: TextStyle(color: Colors.white70)),
              Text("• Use potions when HP is low.", style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CLOSE", style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
    );
  }
}
