import 'dart:math';

// Enums for game types
enum LocationType { city, wilderness, dungeon, cyberSpace }
enum EnemyType { biological, mechanical, magical, hybrid }

class GameState {
  // Singleton pattern
  static final GameState _instance = GameState._internal();
  factory GameState() => _instance;
  GameState._internal();

  // Player Stats
  int playerHp = 100;
  int playerMaxHp = 100;
  int playerEnergy = 50;
  int playerMaxEnergy = 50;
  int playerXp = 0;
  int playerLevel = 1;
  int credits = 100; // Modern currency
  
  // Inventory
  List<String> inventory = ['Rusty Cyber-Blade', 'Health Potion'];
  
  // World State
  Location currentLocation = Location(
    name: "Neo-Arcadia Central Plaza",
    description: "Neon lights flicker against ancient stone statues. Drones buzz overhead while merchants sell potions and microchips.",
    type: LocationType.city,
    possibleEnemies: [],
  );
  
  Enemy? currentEnemy;
  List<String> adventureLog = [
    "Welcome to Neon & Sorcery.",
    "The year is 2099 A.D. (After Dragons).",
    "Magic has returned to a cyberpunk world.",
  ];

  // Game Logic Methods
  void addLog(String message) {
    adventureLog.insert(0, message);
    if (adventureLog.length > 50) adventureLog.removeLast();
  }

  void healPlayer(int amount) {
    playerHp = min(playerHp + amount, playerMaxHp);
    addLog("You healed for $amount HP.");
  }

  void takeDamage(int amount) {
    playerHp = max(playerHp - amount, 0);
    addLog("You took $amount damage!");
  }
  
  void useEnergy(int amount) {
    playerEnergy = max(playerEnergy - amount, 0);
  }

  void gainXp(int amount) {
    playerXp += amount;
    addLog("Gained $amount XP.");
    if (playerXp >= playerLevel * 100) {
      playerLevel++;
      playerMaxHp += 20;
      playerHp = playerMaxHp;
      playerMaxEnergy += 10;
      playerEnergy = playerMaxEnergy;
      playerXp = 0;
      addLog("LEVEL UP! You are now level $playerLevel.");
    }
  }

  void resetGame() {
    playerHp = 100;
    playerMaxHp = 100;
    playerEnergy = 50;
    playerMaxEnergy = 50;
    playerXp = 0;
    playerLevel = 1;
    credits = 100;
    inventory = ['Rusty Cyber-Blade', 'Health Potion'];
    currentEnemy = null;
    adventureLog = [
      "Welcome to Neon & Sorcery.",
      "The year is 2099 A.D. (After Dragons).",
      "Magic has returned to a cyberpunk world.",
    ];
    currentLocation = Location(
      name: "Neo-Arcadia Central Plaza",
      description: "Neon lights flicker against ancient stone statues. Drones buzz overhead.",
      type: LocationType.city,
      possibleEnemies: [],
    );
  }
}

class Location {
  final String name;
  final String description;
  final LocationType type;
  final List<Enemy> possibleEnemies;

  Location({
    required this.name,
    required this.description,
    required this.type,
    required this.possibleEnemies,
  });
}

class Enemy {
  final String name;
  final String description;
  final EnemyType type;
  int hp;
  final int maxHp;
  final int damage;
  final int xpReward;

  Enemy({
    required this.name,
    required this.description,
    required this.type,
    required this.hp,
    required this.maxHp,
    required this.damage,
    required this.xpReward,
  });
}

// Data Generators
class GameData {
  static List<Location> locations = [
    Location(
      name: "Neo-Arcadia Central Plaza",
      description: "The hub of the city. Holographic wizards advertise mana-potions.",
      type: LocationType.city,
      possibleEnemies: [],
    ),
    Location(
      name: "Cyber-Sewers",
      description: "Dark, damp, and filled with rogue nanobots and slime monsters.",
      type: LocationType.dungeon,
      possibleEnemies: [
        Enemy(name: "Nano-Slime", description: "A gelatinous blob infused with aggressive nanites.", type: EnemyType.hybrid, hp: 30, maxHp: 30, damage: 5, xpReward: 20),
        Enemy(name: "Rat-Borg", description: "A giant rat with a cybernetic eye and metal claws.", type: EnemyType.mechanical, hp: 25, maxHp: 25, damage: 8, xpReward: 15),
      ],
    ),
    Location(
      name: "The Silicon Forest",
      description: "Trees made of fiber-optics and synthetic wood. Ancient spirits haunt the data streams.",
      type: LocationType.wilderness,
      possibleEnemies: [
        Enemy(name: "Data-Wisp", description: "A floating ball of corrupted code and spirit energy.", type: EnemyType.magical, hp: 20, maxHp: 20, damage: 12, xpReward: 25),
        Enemy(name: "Cyber-Wolf", description: "A wolf with titanium plating.", type: EnemyType.biological, hp: 40, maxHp: 40, damage: 10, xpReward: 30),
      ],
    ),
    Location(
      name: "Old World Ruins",
      description: "Crumbling stone castles from before the Tech Age. Dragons are rumored to nest here.",
      type: LocationType.dungeon,
      possibleEnemies: [
        Enemy(name: "Skeleton Guard", description: "Animated bones wielding a rusty laser rifle.", type: EnemyType.hybrid, hp: 50, maxHp: 50, damage: 15, xpReward: 40),
        Enemy(name: "Techno-Lich", description: "An undead wizard plugged into a mainframe.", type: EnemyType.magical, hp: 80, maxHp: 80, damage: 20, xpReward: 100),
      ],
    ),
  ];

  static Location getRandomLocation() {
    final random = Random();
    return locations[random.nextInt(locations.length)];
  }
  
  static Enemy? getRandomEnemy(Location location) {
    if (location.possibleEnemies.isEmpty) return null;
    final random = Random();
    // 60% chance to encounter an enemy in dangerous zones
    if (random.nextDouble() > 0.4) {
      final enemyTemplate = location.possibleEnemies[random.nextInt(location.possibleEnemies.length)];
      return Enemy(
        name: enemyTemplate.name,
        description: enemyTemplate.description,
        type: enemyTemplate.type,
        hp: enemyTemplate.hp,
        maxHp: enemyTemplate.maxHp,
        damage: enemyTemplate.damage,
        xpReward: enemyTemplate.xpReward,
      );
    }
    return null;
  }
}
