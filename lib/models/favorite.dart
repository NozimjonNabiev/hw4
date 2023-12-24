import 'package:hw4/database/db_helper.dart';

class Favorite {
  int id;
  int userId;
  String word;

  Favorite({
    required this.userId,
    required this.word,
    this.id = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      DBHelper.COLUMN_ID: id,
      DBHelper.COLUMN_USER_ID: userId,
      DBHelper.COLUMN_WORD: word,
    };
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map[DBHelper.COLUMN_ID],
      userId: map[DBHelper.COLUMN_USER_ID],
      word: map[DBHelper.COLUMN_WORD],
    );
  }
}
