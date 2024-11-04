import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'user.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = join(await getDatabasesPath(), 'usersDB_task1.db');
    print("Database path: $dbPath");
    return openDatabase(
      dbPath,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(name TEXT, '
              'phone TEXT, ssn TEXT PRIMARY KEY, address TEXT)',

        );
      },
      version: 1,
    );
  }

  //Insert
  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Get
  Future<User?> getUser(String name, String ssn) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'name = ? AND ssn = ?',
      whereArgs: [name, ssn],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      return null;
    }
  }

  //Delete
  Future<void> deleteUser(String ssn) async {
    final db = await database;
    await db.delete(
      'users',
      where: 'ssn = ?',
      whereArgs: [ssn],
    );
  }

  Future<void> updateUser(String ssn, String name, String phone, String address) async {
    final db = await database;

    await db.update(
      'users',
      {
        'name': name,
        'phone': phone,
        'address': address,
      },
      where: 'ssn = ?',
      whereArgs: [ssn],
    );
  }


  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('users');
  }


}
