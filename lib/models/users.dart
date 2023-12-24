import 'package:hw4/database/db_helper.dart';

class User {
  int id;
  String firstName;
  String lastName;
  String dob;
  String email;
  String password;

  User({
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.email,
    required this.password,
    this.id = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      DBHelper.COLUMN_ID: id,
      DBHelper.COLUMN_FIRST_NAME: firstName,
      DBHelper.COLUMN_LAST_NAME: lastName,
      DBHelper.COLUMN_DOB: dob,
      DBHelper.COLUMN_EMAIL: email,
      DBHelper.COLUMN_PASSWORD: password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map[DBHelper.COLUMN_ID],
      firstName: map[DBHelper.COLUMN_FIRST_NAME],
      lastName: map[DBHelper.COLUMN_LAST_NAME],
      dob: map[DBHelper.COLUMN_DOB],
      email: map[DBHelper.COLUMN_EMAIL],
      password: map[DBHelper.COLUMN_PASSWORD],
    );
  }
}
