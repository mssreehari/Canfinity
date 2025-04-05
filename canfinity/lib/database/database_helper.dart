import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:canfinity/screens/chemo_tracking_screen.dart'; // to access ChemoSession model
import 'package:canfinity/screens/medicine_reminders_tab.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'canfinity.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE chemo_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sessionNumber INTEGER,
        date TEXT,
        duration TEXT,
        notes TEXT
      )
    ''');

  await db.execute('''
    CREATE TABLE medicine_reminders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      medicineName TEXT,
      time TEXT,
      dosage TEXT,
      notes TEXT,
      isActive INTEGER
    )
  ''');
  }

  // Insert session
  Future<int> insertChemoSession(ChemoSession session) async {
    final db = await database;
    return await db.insert('chemo_sessions', session.toMap());
  }

  // Get all sessions
  Future<List<ChemoSession>> getChemoSessions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('chemo_sessions');
    return maps.map((map) => ChemoSession.fromMap(map)).toList();
  }

  // Delete session
  Future<int> deleteChemoSession(int id) async {
    final db = await database;
    return await db.delete('chemo_sessions', where: 'id = ?', whereArgs: [id]);
  }
  // Insert medicine reminder
  Future<int> insertMedicineReminder(MedicineReminder reminder) async {
    try {
      final db = await database;
      print("INSERTING: ${reminder.toMap()}");
      return await db.insert('medicine_reminders', reminder.toMap());
    } catch (e) {
      print("INSERT ERROR: $e");
      return -1;
    }
  }


// Get all medicine reminders
  Future<List<MedicineReminder>> getMedicineReminders() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('medicine_reminders');

      print("📦 Loaded ${maps.length} rows from DB:");
      for (var row in maps) {
        print(row); // debug print each row
      }

      return maps.map((map) {
        try {
          return MedicineReminder.fromMap(map);
        } catch (e) {
          print("❌ Failed to parse reminder: $map — $e");
          return null;
        }
      }).whereType<MedicineReminder>().toList();

    } catch (e) {
      print("❗ getMedicineReminders failed: $e");
      return [];
    }
  }


// Delete a medicine reminder
  Future<int> deleteMedicineReminder(int id) async {
    final db = await database;
    return await db.delete('medicine_reminders', where: 'id = ?', whereArgs: [id]);
  }

}
