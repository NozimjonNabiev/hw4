import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../models/users.dart';
import '../models/favorite.dart';

class DBHelper {
  static Database? _db;

  static const String TABLE_USERS = 'users';
  static const String COLUMN_ID = 'id';
  static const String COLUMN_FIRST_NAME = 'first_name';
  static const String COLUMN_LAST_NAME = 'last_name';
  static const String COLUMN_DOB = 'dob';
  static const String COLUMN_EMAIL = 'email';
  static const String COLUMN_PASSWORD = 'password';

  static const String TABLE_FAVORITES = 'favorites';
  static const String COLUMN_USER_ID = 'user_id';
  static const String COLUMN_WORD = 'word';

  // Singleton pattern and initialization methods remain the same

  static Future<void> initDb() async {
    _db = await openDatabase(
      'myDictionary.db',
      version: 1,
      onCreate: _createDb,
    );
  }

  static Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $TABLE_USERS (
        $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COLUMN_FIRST_NAME TEXT NOT NULL,
        $COLUMN_LAST_NAME TEXT NOT NULL,
        $COLUMN_DOB TEXT NOT NULL,
        $COLUMN_EMAIL TEXT UNIQUE NOT NULL,
        $COLUMN_PASSWORD TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $TABLE_FAVORITES (
        $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COLUMN_USER_ID INTEGER NOT NULL,
        $COLUMN_WORD TEXT NOT NULL,
        FOREIGN KEY ($COLUMN_USER_ID) REFERENCES $TABLE_USERS($COLUMN_ID)
      )
    ''');
  }

  static Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    await initDb();
    return _db!;
  }

  // User-related operations
  static Future<int> insertUser(User user) async {
    Database? db = await DBHelper.db;
    return await db.insert(TABLE_USERS, user.toMap());
  }

  static Future<List<User>> getUsers() async {
    Database? db = await DBHelper.db;
    List<Map<String, dynamic>> usersMap = await db.query(TABLE_USERS);
    return usersMap.map((userMap) => User.fromMap(userMap)).toList();
  }

  static Future<User?> getUserByEmailAndPassword(
      String email, String password) async {
    Database? db = await DBHelper.db;
    List<Map<String, dynamic>> result = await db.query(
      DBHelper.TABLE_USERS,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      return null;
    }
  }

  static Future<User?> getUser(int id) async {
    Database? db = await DBHelper.db;
    List<Map<String, dynamic>> usersMap =
        await db.query(TABLE_USERS, where: '$COLUMN_ID = ?', whereArgs: [id]);
    if (usersMap.isNotEmpty) {
      return User.fromMap(usersMap.first);
    } else {
      return null;
    }
  }

  static Future<int?> getUserIdByEmail(String email) async {
    Database? db = await DBHelper.db;
    final List<Map<String, dynamic>> result = await db.query(
      TABLE_USERS,
      columns: [COLUMN_ID],
      where: '$COLUMN_EMAIL = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return result.first[COLUMN_ID];
    }

    return null;
  }

  static Future<int> updateUser(User user) async {
    Database? db = await DBHelper.db;
    return await db.update(TABLE_USERS, user.toMap(),
        where: '$COLUMN_ID = ?', whereArgs: [user.id]);
  }

  static Future<int> deleteUser(int id) async {
    Database? db = await DBHelper.db;
    return await db
        .delete(TABLE_USERS, where: '$COLUMN_ID = ?', whereArgs: [id]);
  }

  // Favorite-related operations
  static Future<int> insertFavorite(int userId, String word) async {
    Database? db = await DBHelper.db;
    return await db.insert(TABLE_FAVORITES, {
      COLUMN_USER_ID: userId,
      COLUMN_WORD: word,
    });
  }

  static Future<int> deleteFavorite(int userId, String word) async {
    Database? db = await DBHelper.db;
    return await db.delete(
      TABLE_FAVORITES,
      where: '$COLUMN_USER_ID = ? AND $COLUMN_WORD = ?',
      whereArgs: [userId, word],
    );
  }

  static Future<bool> isWordFavorite(int userId, String word) async {
    Database? db = await DBHelper.db;
    final List<Map<String, dynamic>> result = await db.query(
      TABLE_FAVORITES,
      where: '$COLUMN_USER_ID = ? AND $COLUMN_WORD = ?',
      whereArgs: [userId, word],
    );
    return result.isNotEmpty;
  }

  static Future<List<Favorite>> getFavorites(int userId) async {
    Database? db = await DBHelper.db;
    List<Map<String, dynamic>> favoritesMap = await db.query(
      TABLE_FAVORITES,
      where: '$COLUMN_USER_ID = ?',
      whereArgs: [userId],
    );
    return favoritesMap
        .map((favoriteMap) => Favorite.fromMap(favoriteMap))
        .toList();
  }
}
