import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes_app.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  
  Future<void> _onCreate(Database db, int version) async {
  
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        userId INTEGER,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
  }

  Future<int> createUser(String username, String password) async {
    final db = await database;

    return await db.insert('users', {
      'username': username,
      'password': password,
    });
  }

  Future<Map<String, dynamic>?> getUser(
    String username,
    String password,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }


  // Créer une nouvelle note
  Future<int> createNote(String title, String content) async {
    final db = await database;
    return await db.insert('notes', {'title': title, 'content': content});
  }

  // Lire une seule note par son id
  Future<Map<String, dynamic>?> getNote(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  // Lire toutes les notes
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final db = await database;
    return await db.query(
      'notes',
      orderBy: 'id DESC',
    ); 
  }

  // Mettre à jour une note
  Future<int> updateNote(int id, String title, String content) async {
    final db = await database;
    return await db.update(
      'notes',
      {'title': title, 'content': content},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Supprimer une note
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
