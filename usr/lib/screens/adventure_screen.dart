import 'dart:math';
import 'package:flutter/material.dart';
import 'package:couldai_user_app/game_engine/game_state.dart';

class AdventureScreen extends StatefulWidget {
  const AdventureScreen({super.key});

  @override
  State<AdventureScreen> createState() => _AdventureScreenState();
}

class _AdventureScreenState extends State<AdventureScreen> {
  final GameState _gameState = GameState();
  final ScrollController _logScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  void _updateState() {
    setState(() {});
  }

  // --- Actions ---

  void _travel() {
    if (_gameState.currentEnemy != null) {
      _gameState.addLog("Cannot travel while in combat!");
      _updateState();
      return;
    }

    Location newLoc = GameData.getRandomLocation();
    _gameState.currentLocation = newLoc;
    _gameState.addLog("Traveled to ${newLoc.name}.");
    
    // Chance for encounter
    Enemy? enemy = GameData.getRandomEnemy(newLoc);
    if (enemy != null) {
      _gameState.currentEnemy = enemy;
      _gameState.addLog("WARNING: ${enemy.name} detected!");
    } else {
      _gameState.addLog("The area seems clear.");
    }
    _updateState();
  }

  void _attack() {
    if (_gameState.currentEnemy == null) {
      _gameState.addLog("Nothing to attack here.");
      _updateState();
      return;
    }

    // Player attacks
    int damage = Random().nextInt(10) + 5 + (_gameState.playerLevel * 2); // Base 5-15 + level scaling
    _gameState.currentEnemy!.hp -= damage;
    _gameState.addLog("You hit ${_gameState.currentEnemy!.name} for $damage DMG.");

    _checkEnemyDeath();
    if (_gameState.currentEnemy != null) {
      _enemyTurn();
    }
    _updateState();
  }

  void _castSpell() {
    if (_gameState.currentEnemy == null) {
      _gameState.addLog("No target for spells.");
      _updateState();
      return;
    }
    
    if (_gameState.playerEnergy < 10) {
      _gameState.addLog("Not enough energy (Need 10).");
      _updateState();
      return;
    }

    _gameState.useEnergy(10);
    int damage = Random().nextInt(15) + 15 + (_gameState.playerLevel * 3); // Stronger than attack
    _gameState.currentEnemy!.hp -= damage;
    _gameState.addLog("You cast 'Cyber-Flare'! Dealt $damage DMG.");

    _checkEnemyDeath();
    if (_gameState.currentEnemy != null) {
      _enemyTurn();
    }
    _updateState();
  }

  void _heal() {
    if (_gameState.inventory.contains('Health Potion')) {
      _gameState.inventory.remove('Health Potion');
      _gameState.healPlayer(50);
      _gameState.addLog("Used Health Potion.");
      
      if (_gameState.currentEnemy != null) {
        _enemyTurn();
      }
    } else {
      _gameState.addLog("No potions left!");
    }
    _updateState();
  }

  void _scavenge() {
    if (_gameState.currentEnemy != null) {
      _gameState.addLog("Cannot scavenge during combat!");
      _updateState();
      return;
    }

    if (Random().nextBool()) {
      _gameState.inventory.add('Health Potion');
      _gameState.addLog("Found a Health Potion!");
    } else {
      int creditsFound = Random().nextInt(20) + 5;
      _gameState.credits += creditsFound;
      _gameState.addLog("Found $creditsFound credits.");
    }
    _updateState();
  }

  // --- Combat Logic ---

  void _checkEnemyDeath() {
    if (_gameState.currentEnemy!.hp <= 0) {
      _gameState.addLog("Target eliminated: ${_gameState.currentEnemy!.name}.");
      _gameState.gainXp(_gameState.currentEnemy!.xpReward);
      _gameState.currentEnemy = null;
      
      // Loot chance
      if (Random().nextDouble() > 0.7) {
        _gameState.inventory.add('Health Potion');
        _gameState.addLog("Enemy dropped a Health Potion.");
      }
    }
  }

  void _enemyTurn() {
    if (_gameState.currentEnemy == null) return;

    int damage = _gameState.currentEnemy!.damage;
    // Small variance
    damage = (damage * (0.8 + Random().nextDouble() * 0.4)).round();
    
    _gameState.takeDamage(damage);
    _gameState.addLog("${_gameState.currentEnemy!.name} attacks you for $damage DMG.");

    if (_gameState.playerHp <= 0) {
      _gameState.addLog("CRITICAL FAILURE. SYSTEM SHUTDOWN.");
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red.shade900,
        title: const Text("GAME OVER", style: TextStyle(color: Colors.white)),
        content: const Text("Your signal has been lost...", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pushReplacementNamed('/'); // Go to title
            },
            child: const Text("REBOOT", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildStatBar(String label, int current, int max, Color color, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text("$label: $current/$max", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: max > 0 ? current / max : 0,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2A2A2A),
        foregroundColor: color,
        side: BorderSide(color: color.withOpacity(0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("LVL ${_gameState.playerLevel} Technomancer", style: const TextStyle(color: Colors.cyanAccent, fontSize: 16)),
            Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text("${_gameState.credits}", style: const TextStyle(color: Colors.amber, fontSize: 16)),
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: [
          // 1. Visual Scene Area
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.cyanAccent.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(8),
                // Removed NetworkImage to prevent web preview CORS issues
                // Using gradient and icons instead
              ),
              child: Stack(
                children: [
                  // Background gradient based on location type
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: _getLocationColors(_gameState.currentLocation.type),
                      ),
                    ),
                  ),
                  
                  // Decorative Grid Pattern (Cyberpunk feel)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: GridPainter(color: Colors.cyanAccent.withOpacity(0.1)),
                    ),
                  ),

                  // Location Info
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _gameState.currentLocation.name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _gameState.currentLocation.description,
                          style: const TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),

                  // Enemy Display
                  if (_gameState.currentEnemy != null)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.8, end: 1.0),
                            duration: const Duration(milliseconds: 500),
                            builder: (context, value, child) {
                              return Transform.scale(scale: value, child: child);
                            },
                            child: Icon(
                              _getEnemyIcon(_gameState.currentEnemy!.type),
                              size: 100,
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              border: Border.all(color: Colors.redAccent),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  _gameState.currentEnemy!.name,
                                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                Text(
                                  "HP: ${_gameState.currentEnemy!.hp}/${_gameState.currentEnemy!.maxHp}",
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Center(
                      child: Icon(
                        _getLocationIcon(_gameState.currentLocation.type),
                        size: 80,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // 2. Player Stats Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(child: _buildStatBar("HP", _gameState.playerHp, _gameState.playerMaxHp, Colors.greenAccent, Icons.favorite)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatBar("ENERGY", _gameState.playerEnergy, _gameState.playerMaxEnergy, Colors.blueAccent, Icons.flash_on)),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 3. Action Grid
          Container(
            height: 140,
            padding: const EdgeInsets.all(8),
            child: GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.2,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildActionButton("ATTACK", Icons.gavel, _attack, Colors.redAccent),
                _buildActionButton("SPELL", Icons.auto_fix_high, _castSpell, Colors.purpleAccent),
                _buildActionButton("HEAL", Icons.local_hospital, _heal, Colors.greenAccent),
                _buildActionButton("TRAVEL", Icons.map, _travel, Colors.orangeAccent),
                _buildActionButton("SCAVENGE", Icons.search, _scavenge, Colors.amber),
                _buildActionButton("INVENTORY", Icons.backpack, () {
                   _gameState.addLog("Inventory: ${_gameState.inventory.join(', ')}");
                   _updateState();
                }, Colors.grey),
              ],
            ),
          ),

          // 4. Adventure Log
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: const Color(0xFF050505),
              child: ListView.builder(
                controller: _logScrollController,
                padding: const EdgeInsets.all(8),
                itemCount: _gameState.adventureLog.length,
                itemBuilder: (context, index) {
                  // Highlight the first message (latest)
                  final isLatest = index == 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      "> ${_gameState.adventureLog[index]}",
                      style: TextStyle(
                        color: isLatest ? Colors.cyanAccent : Colors.white60,
                        fontWeight: isLatest ? FontWeight.bold : FontWeight.normal,
                        fontFamily: 'Courier',
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helpers for visuals
  List<Color> _getLocationColors(LocationType type) {
    switch (type) {
      case LocationType.city:
        return [Colors.purple.withOpacity(0.3), Colors.blue.withOpacity(0.3)];
      case LocationType.wilderness:
        return [Colors.green.withOpacity(0.2), Colors.brown.withOpacity(0.4)];
      case LocationType.dungeon:
        return [Colors.black, Colors.grey.shade900];
      case LocationType.cyberSpace:
        return [Colors.blueAccent.withOpacity(0.4), Colors.cyan.withOpacity(0.4)];
    }
  }

  IconData _getLocationIcon(LocationType type) {
    switch (type) {
      case LocationType.city: return Icons.location_city;
      case LocationType.wilderness: return Icons.forest;
      case LocationType.dungeon: return Icons.castle;
      case LocationType.cyberSpace: return Icons.hub;
    }
  }

  IconData _getEnemyIcon(EnemyType type) {
    switch (type) {
      case EnemyType.biological: return Icons.pets;
      case EnemyType.mechanical: return Icons.smart_toy;
      case EnemyType.magical: return Icons.auto_awesome;
      case EnemyType.hybrid: return Icons.android;
    }
  }
}

// Simple painter for a retro grid effect
class GridPainter extends CustomPainter {
  final Color color;
  GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const step = 40.0;
    
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
